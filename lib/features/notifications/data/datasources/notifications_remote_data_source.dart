import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/notifications_dto.dart';
import 'notifications_data_source.dart';

final notificationsRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
      return NotificationsRemoteDataSource(ref.watch(apiClientProvider));
    });

/// Real notifications over REST. The Bearer token is injected by the API
/// client's interceptor (from `AuthSessionStore`), so the `accessToken` the
/// repository passes is unused here — kept in the interface for the
/// fake/offline path. Push delivery (FCM) is a separate, deferred concern;
/// v1 fetches the list on open and after each mutation.
class NotificationsRemoteDataSource implements NotificationsDataSource {
  const NotificationsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<NotificationsDto> fetchNotifications({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<NotificationsDto>(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'limit': limit},
      decode: NotificationsDto.fromJsonFlexible,
    );
    return response.data ?? NotificationsDto.empty();
  }

  @override
  Future<void> markRead({
    required String? accessToken,
    required String id,
  }) async {
    await _apiClient.patch<void>(
      ApiEndpoints.markNotificationRead(id),
      decode: (_) {},
    );
  }

  @override
  Future<void> markAllRead({required String? accessToken}) async {
    await _apiClient.patch<void>(
      ApiEndpoints.markAllNotificationsRead,
      decode: (_) {},
    );
  }

  @override
  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  }) async {
    await _apiClient.delete<void>(
      ApiEndpoints.notificationById(id),
      decode: (_) {},
    );
  }

  @override
  Future<void> registerDeviceToken({
    required String? accessToken,
    required String token,
    String? deviceType,
  }) async {
    await _apiClient.post<void>(
      ApiEndpoints.notificationToken,
      data: {'token': token, 'device_type': ?deviceType},
      decode: (_) {},
    );
  }
}
