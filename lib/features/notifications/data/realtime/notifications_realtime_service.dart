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
final notificationsRealtimeServiceProvider =
    Provider<NotificationsRealtimeService>((ref) {
      final service = NotificationsRealtimeService(ref);
      ref.onDispose(service.dispose);
      return service;
    });

class NotificationsRealtimeService {
  NotificationsRealtimeService(this._ref) {
    _authSub = _ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final wasAuthed = previous?.isAuthenticated ?? false;
      if (next.isAuthenticated && !wasAuthed) {
        unawaited(_connect());
      } else if (!next.isAuthenticated && wasAuthed) {
        _disconnect();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  ProviderSubscription<AuthState>? _authSub;
  realtime.RealtimeClient? _client;
  realtime.RealtimeChannel? _channel;
  final _controller = StreamController<AppNotification>.broadcast();

  /// Each new notification row inserted for the signed-in user.
  Stream<AppNotification> get notifications => _controller.stream;

  Future<void> _connect() async {
    _disconnect();

    final session = await _ref.read(authSessionStoreProvider).read();
    final token = session?.tokens?.accessToken;
    if (token == null || token.isEmpty) {
      return;
    }

    final config = _ref.read(appConfigProvider);
    final wsUrl = '${config.supabaseUrl}/realtime/v1'.replaceFirst('http', 'ws');
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
