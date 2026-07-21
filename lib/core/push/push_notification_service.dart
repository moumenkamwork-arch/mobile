import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../routing/app_router.dart';
import '../../routing/route_names.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService?>((
  ref,
) {
  PushNotificationService service;
  try {
    // Firebase.initializeApp() in main.dart is itself best-effort (never
    // crashes app start) — FirebaseMessaging.instance throws if that init
    // didn't happen or didn't complete, so this must degrade the same way
    // rather than taking the whole app down with it.
    service = PushNotificationService(
      repository: ref.watch(notificationsRepositoryProvider),
      router: ref.watch(appRouterProvider),
    );
  } catch (_) {
    return null;
  }

  // Listen to auth changes to register token when user logs in
  ref.listen(authControllerProvider, (previous, next) {
    if (next.status == AuthStatus.authenticated) {
      service.setupAndRegisterToken();
    } else if (next.status == AuthStatus.unauthenticated) {
      // We could delete token here, but it's optional
    }
  });

  return service;
});

class PushNotificationService {
  PushNotificationService({required this.repository, required this.router});

  final NotificationsRepository repository;
  final GoRouter router;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission for iOS/Android 13+
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('Received foreground push notification: ${message.messageId}');
        }
      });

      // App was in background and got brought to the foreground by a tap.
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      // App was fully terminated and launched fresh by tapping the
      // notification — `onMessageOpenedApp` never fires for this case.
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    }
  }

  Future<void> setupAndRegisterToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _registerTokenWithBackend(token);
      }
      _messaging.onTokenRefresh.listen(_registerTokenWithBackend);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to setup FCM token: $e');
      }
    }
  }

  Future<void> _registerTokenWithBackend(String token) async {
    String deviceType = 'web';
    if (!kIsWeb) {
      deviceType = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown');
    }

    await repository.registerDeviceToken(
      token: token,
      deviceType: deviceType,
    );
  }

  /// Same destination rule as the in-app notifications list
  /// (`notifications_screen.dart:_openNotification`): a `room_id` always wins
  /// (it means a chat message), otherwise a `follow` type opens the follower's
  /// profile. Uses `router.push` directly — no `BuildContext` is available
  /// here (this fires from a background/terminated-app message handler).
  void _handleMessageTap(RemoteMessage message) {
    final data = message.data;

    final roomId = data['room_id'];
    if (roomId is String && roomId.isNotEmpty) {
      router.push(AppRoutes.chatRoom(roomId));
      return;
    }

    if (data['type'] == 'follow') {
      final followerId = data['follower_id'];
      if (followerId is String && followerId.isNotEmpty) {
        router.push(AppRoutes.profileById(followerId));
      }
    }
  }
}

// Background handler must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}
