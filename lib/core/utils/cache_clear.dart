import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/chat/data/realtime/chat_realtime_service.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/my_listings/presentation/controllers/my_listings_controller.dart';
import '../../features/notifications/data/realtime/notifications_realtime_service.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/saved/presentation/controllers/saved_controller.dart';

/// Centralized utility to clear/invalidate ALL user-specific in-memory caches
/// when auth state changes (login, logout, session expiry).
///
/// Do **not** call this synchronously from inside an [AuthController] state
/// write. Several targets (chat / notifications) listen to
/// `authControllerProvider`, so invalidating them mid-update trips Riverpod's
/// circular-dependency assert. Callers must schedule this after auth state
/// settles (see `AuthController._scheduleClearUserSessionCaches`).
///
/// Invalidation must go through [ProviderContainer], not [Ref.invalidate].
/// In Riverpod 3, `ref.invalidate(X)` from AuthController asserts that X is
/// not a descendant of auth. Chat/notifications realtime services *listen* to
/// auth, so they are descendants — using `ref.invalidate` throws
/// [CircularDependencyError] even from a microtask.
///
/// Strategy:
/// - [profileControllerProvider] holds the current user's profile state.
/// - [editProfileSourceProvider] is `autoDispose` so it self-clears when the
///   screen is popped, but we also invalidate it here so it never leaks across
///   login cycles even if the screen is somehow still active.
/// - Everything else ([savedControllerProvider], [myListingsControllerProvider],
///   [chatControllerProvider], [chatRealtimeServiceProvider],
///   [notificationsControllerProvider], [notificationsRealtimeServiceProvider])
///   holds per-user data that must not outlive a session.
/// - The image cache is cleared so a previous user's avatar/media images are
///   not shown momentarily before the new user's images load.
void clearUserSessionCaches(Ref ref) {
  final container = ref.container;

  // Core per-user providers
  container.invalidate(profileControllerProvider);
  container.invalidate(editProfileSourceProvider);
  container.invalidate(savedControllerProvider);
  container.invalidate(myListingsControllerProvider);

  // Chat — also kills the realtime subscription so the new user starts clean
  container.invalidate(chatControllerProvider);
  container.invalidate(chatRealtimeServiceProvider);

  // Notifications
  container.invalidate(notificationsControllerProvider);
  container.invalidate(notificationsRealtimeServiceProvider);

  // Clear in-memory image cache so previous user's images aren't retained
  try {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  } catch (_) {
    // WidgetsBinding not initialized in raw unit test environment — safe to ignore
  }
}
