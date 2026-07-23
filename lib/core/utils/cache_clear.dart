import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/chat/data/realtime/chat_realtime_service.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/my_listings/presentation/controllers/my_listings_controller.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/saved/presentation/controllers/saved_controller.dart';

/// Centralized utility to clear/invalidate ALL user-specific in-memory caches
/// when auth state changes (login, logout, session expiry).
///
/// Strategy:
/// - [profileControllerProvider] holds the current user's profile state.
/// - [editProfileSourceProvider] is `autoDispose` so it self-clears when the
///   screen is popped, but we also invalidate it here so it never leaks across
///   login cycles even if the screen is somehow still active.
/// - Everything else ([savedControllerProvider], [myListingsControllerProvider],
///   [chatControllerProvider], [chatRealtimeServiceProvider],
///   [notificationsControllerProvider]) holds per-user data that must not
///   outlive a session.
/// - The image cache is cleared so a previous user's avatar/media images are
///   not shown momentarily before the new user's images load.
void clearUserSessionCaches(Ref ref) {
  // Core per-user providers
  ref.invalidate(profileControllerProvider);
  ref.invalidate(editProfileSourceProvider);
  ref.invalidate(savedControllerProvider);
  ref.invalidate(myListingsControllerProvider);

  // Chat — also kills the realtime subscription so the new user starts clean
  ref.invalidate(chatControllerProvider);
  ref.invalidate(chatRealtimeServiceProvider);

  // Notifications
  ref.invalidate(notificationsControllerProvider);

  // Clear in-memory image cache so previous user's images aren't retained
  try {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  } catch (_) {
    // WidgetsBinding not initialized in raw unit test environment — safe to ignore
  }
}
