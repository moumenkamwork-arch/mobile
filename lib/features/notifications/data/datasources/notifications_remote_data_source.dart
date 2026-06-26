import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/notifications_dto.dart';
import 'notifications_data_source.dart';

final notificationsRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
      return NotificationsRemoteDataSource(ref.watch(apiClientProvider));
    });

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
      headers: _authHeaders(accessToken),
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
      headers: _authHeaders(accessToken),
    );
  }

  @override
  Future<void> markAllRead({required String? accessToken}) async {
    await _apiClient.patch<void>(
      ApiEndpoints.markAllNotificationsRead,
      headers: _authHeaders(accessToken),
    );
  }

  @override
  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  }) async {
    await _apiClient.delete<void>(
      ApiEndpoints.notificationById(id),
      headers: _authHeaders(accessToken),
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
      headers: _authHeaders(accessToken),
      data: {
        'token': token,
        if (deviceType != null && deviceType.trim().isNotEmpty)
          'device_type': deviceType,
      },
    );
  }
}

Map<String, Object?>? _authHeaders(String? accessToken) {
  if (accessToken == null || accessToken.trim().isEmpty) {
    return null;
  }
  return {'Authorization': 'Bearer $accessToken'};
}
