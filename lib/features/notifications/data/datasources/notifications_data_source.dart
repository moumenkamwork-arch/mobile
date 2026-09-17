import '../dto/notifications_dto.dart';

abstract interface class NotificationsDataSource {
  Future<NotificationsDto> fetchNotifications({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  });

  Future<void> markRead({required String? accessToken, required String id});

  Future<void> markAllRead({required String? accessToken});

  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  });

  Future<void> registerDeviceToken({
    required String? accessToken,
    required String token,
    String? deviceType,
  });
}
