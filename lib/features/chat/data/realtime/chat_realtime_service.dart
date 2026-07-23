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
        _disconnect();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  ProviderSubscription<AuthState>? _authSub;
  realtime.RealtimeClient? _client;
  realtime.RealtimeChannel? _channel;
  final _controller = StreamController<ChatMessage>.broadcast();

  /// Every new message inserted into a room the signed-in user participates
  /// in — including their own sends echoed back, which is fine since
  /// consumers dedup by the message's real id.
  Stream<ChatMessage> get messages => _controller.stream;

  Future<void> _connect() async {
    _disconnect();

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
    channel.subscribe();

    _client = client;
    _channel = channel;
  }

  void _disconnect() {
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
    _authSub?.close();
    _disconnect();
    unawaited(_controller.close());
  }
}
