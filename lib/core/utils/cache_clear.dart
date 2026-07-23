import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/chat/data/realtime/chat_realtime_service.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/my_listings/presentation/controllers/my_listings_controller.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/saved/presentation/controllers/saved_controller.dart';

/// Centralized utility to clear/invalidate all user-specific in-memory caches
/// when auth state changes (logout, session expiry).
void clearUserSessionCaches(Ref ref) {
  ref.invalidate(profileControllerProvider);
  ref.invalidate(savedControllerProvider);
  ref.invalidate(myListingsControllerProvider);
  ref.invalidate(chatControllerProvider);
  ref.invalidate(chatRealtimeServiceProvider);
  ref.invalidate(notificationsControllerProvider);
}
