import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_client/realtime_client.dart' as realtime;

import '../../../../core/config/app_config.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/chat.dart';
import '../dto/chat_dto.dart';

/// App-wide singleton bridging Supabase Realtime `postgres_changes` on the
/// `messages` table into a stream of domain [ChatMessage]s.
///
/// Auth here is managed entirely by our own backend (not Supabase's GoTrue),
/// so this talks to the Realtime websocket directly via the bare
/// [realtime.RealtimeClient] (not the full `SupabaseClient`, which would
/// also spin up an unused `GoTrueClient` and its auto-refresh timer) using
/// only the public anon key plus the same Supabase-issued JWT the backend
/// already hands us on login — set via `setAuth`. Row Level Security on
/// `messages` (participant-only, already verified) scopes each subscription
/// server-side, so a single unfiltered subscription is safe: every
/// signed-in user only ever receives events for rooms they're actually in.
///
/// Listens to both INSERT (new messages) and UPDATE (read-receipt flips from
/// `markRoomRead`) — the latter is what lets a sender see their own message
/// flip to "Read" live, instead of only after the room is reloaded some
/// other way. Both funnel into the same stream: consumers dedup/replace by
/// the message's real id, so an UPDATE for an already-known message simply
/// replaces it in place.
///
/// Self-healing: under a shaky connection, `realtime_client`'s own channel
/// join can report `subscribed` before the server-side event replication is
/// actually live, and that setup can then fail silently — the channel just
/// sits there "connected" and never delivers anything (documented on
/// `RealtimeChannel.subscribe`). A dropped/closed socket has the same
/// symptom. Both are only observable via the `subscribe(callback)` status,
/// which this now wires up: on `channelError`/`closed`/`timedOut` it
/// retries the whole connection with a capped backoff instead of staying
/// silently dead until the app is restarted. [ensureConnected] additionally
/// gives the app root a hook to call on resume-from-background, since a
/// backgrounded socket is often killed by the OS without either side ever
/// firing a close event.
final chatRealtimeServiceProvider = Provider<ChatRealtimeService>((ref) {
  final service = ChatRealtimeService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class ChatRealtimeService {
  ChatRealtimeService(this._ref) {
    _authSub = _ref.listen<AuthState>(authControllerProvider, (
      previous,
      next,
    ) {
      if (next.isAuthenticated && _client == null) {
        unawaited(_connect());
      } else if (!next.isAuthenticated) {
        _teardown();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  ProviderSubscription<AuthState>? _authSub;
  realtime.RealtimeClient? _client;
  realtime.RealtimeChannel? _channel;
  Timer? _retryTimer;
  int _retryAttempt = 0;
  bool _connecting = false;
  bool _disposed = false;
  final _controller = StreamController<ChatMessage>.broadcast();

  /// Capped exponential backoff for reconnect attempts: 2s, 4s, 8s, 16s,
  /// then 30s from then on.
  static const _retryDelaysSeconds = [2, 4, 8, 16, 30];

  /// Every new message inserted into a room the signed-in user participates
  /// in — including their own sends echoed back, which is fine since
  /// consumers dedup by the message's real id.
  Stream<ChatMessage> get messages => _controller.stream;

  /// Call when the app returns to the foreground. No-ops if already
  /// connected; otherwise reconnects immediately rather than waiting on a
  /// pending backoff timer or the library's own heartbeat to notice.
  void ensureConnected() {
    if (_disposed) return;
    final isAuthenticated = _ref.read(authControllerProvider).isAuthenticated;
    if (isAuthenticated && (_client == null || _client!.isConnected != true)) {
      unawaited(_connect());
    }
  }

  Future<void> _connect() async {
    if (_connecting) return;
    _connecting = true;
    _retryTimer?.cancel();
    // Keep the retry backoff — this may itself be a scheduled retry.
    _teardown(resetRetry: false);

    try {
      final session = await _ref.read(authSessionStoreProvider).read();
      final token = session?.tokens?.accessToken;
      final userId = session?.user.id;
      if (token == null || token.isEmpty || userId == null) {
        return;
      }

      final config = _ref.read(appConfigProvider);
      final wsUrl = '${config.supabaseUrl}/realtime/v1'.replaceFirst(
        'http',
        'ws',
      );
      final client = realtime.RealtimeClient(
        wsUrl,
        params: {'apikey': config.supabaseAnonKey},
        headers: {'apikey': config.supabaseAnonKey},
      );
      await client.setAuth(token);

      void handlePayload(realtime.PostgresChangePayload payload) {
        final dto = ChatMessageDto.fromJson(payload.newRecord);
        final message = dto.toDomain(
          fallbackId: 'rt-${DateTime.now().microsecondsSinceEpoch}',
          currentUserId: userId,
        );
        if (message != null) {
          _controller.add(message);
        }
      }

      final channel = client
          .channel('messages-changes')
          .onPostgresChanges(
            event: realtime.PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            callback: handlePayload,
          )
          .onPostgresChanges(
            event: realtime.PostgresChangeEvent.update,
            schema: 'public',
            table: 'messages',
            callback: handlePayload,
          );

      _client = client;
      _channel = channel;

      channel.subscribe((status, error) {
        if (_disposed) return;
        switch (status) {
          case realtime.RealtimeSubscribeStatus.subscribed:
            _retryAttempt = 0;
          case realtime.RealtimeSubscribeStatus.channelError:
          case realtime.RealtimeSubscribeStatus.closed:
          case realtime.RealtimeSubscribeStatus.timedOut:
            _scheduleRetry();
        }
      });
    } finally {
      _connecting = false;
    }
  }

  void _scheduleRetry() {
    if (_disposed) return;
    _retryTimer?.cancel();
    final delay = _retryDelaysSeconds[_retryAttempt.clamp(
      0,
      _retryDelaysSeconds.length - 1,
    )];
    _retryAttempt++;
    _retryTimer = Timer(Duration(seconds: delay), () {
      if (_disposed) return;
      if (_ref.read(authControllerProvider).isAuthenticated) {
        unawaited(_connect());
      }
    });
  }

  void _teardown({bool resetRetry = true}) {
    if (resetRetry) {
      _retryTimer?.cancel();
      _retryTimer = null;
      _retryAttempt = 0;
    }
    final client = _client;
    final channel = _channel;
    if (client != null && channel != null) {
      client.removeChannel(channel);
    }
    client?.disconnect();
    _client = null;
    _channel = null;
  }

  void dispose() {
    _disposed = true;
    _authSub?.close();
    _teardown();
    unawaited(_controller.close());
  }
}
