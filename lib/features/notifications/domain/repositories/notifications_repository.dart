import '../../../../core/utils/result.dart';
import '../entities/app_notification.dart';

abstract interface class NotificationsRepository {
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<Result<void>> markRead(String id);

  Future<Result<void>> markAllRead();

  Future<Result<void>> deleteNotification(String id);

  Future<Result<void>> registerDeviceToken({
    required String token,
    String? deviceType,
  });
}
