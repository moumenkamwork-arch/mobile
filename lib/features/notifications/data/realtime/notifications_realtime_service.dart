import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_client/realtime_client.dart' as realtime;

import '../../../../core/config/app_config.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/app_notification.dart';
import '../dto/notifications_dto.dart';

/// App-wide singleton streaming newly-inserted notifications for the signed-in
/// user over Supabase Realtime.
///
/// Same shape as `ChatRealtimeService`: a bare [realtime.RealtimeClient]
/// (no GoTrue) authenticated with the backend-issued Supabase JWT. Row Level
/// Security on `notifications` (`auth.uid() = profile_id`) scopes the
/// subscription server-side, so a plain INSERT subscription only ever delivers
/// this user's own notifications — a new follower or an incoming message lands
/// in the list (and the header badge) the moment the backend writes it, with
/// no polling.
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
final notificationsRealtimeServiceProvider =
    Provider<NotificationsRealtimeService>((ref) {
      final service = NotificationsRealtimeService(ref);
      ref.onDispose(service.dispose);
      return service;
    });

class NotificationsRealtimeService {
  NotificationsRealtimeService(this._ref) {
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
  final _controller = StreamController<AppNotification>.broadcast();

  /// Capped exponential backoff for reconnect attempts: 2s, 4s, 8s, 16s,
  /// then 30s from then on.
  static const _retryDelaysSeconds = [2, 4, 8, 16, 30];

  /// Each new notification row inserted for the signed-in user.
  Stream<AppNotification> get notifications => _controller.stream;

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
      if (token == null || token.isEmpty) {
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

      final channel = client
          .channel('notifications-inserts')
          .onPostgresChanges(
            event: realtime.PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            callback: (payload) {
              final dto = AppNotificationDto.fromJson(payload.newRecord);
              final notification = dto.toDomain(
                fallbackId: 'rt-${DateTime.now().microsecondsSinceEpoch}',
              );
              if (notification != null) {
                _controller.add(notification);
              }
            },
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
