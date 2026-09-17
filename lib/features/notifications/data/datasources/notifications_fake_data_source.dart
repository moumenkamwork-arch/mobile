import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/notifications_dto.dart';
import 'notifications_data_source.dart';

final notificationsFakeDataSourceProvider =
    Provider<NotificationsFakeDataSource>((ref) {
      return NotificationsFakeDataSource();
    });

class NotificationsFakeDataSource implements NotificationsDataSource {
  NotificationsFakeDataSource()
    : _notifications = [
        {
          'id': 'notification-1',
          'title': 'New message',
          'body': 'Saffron Social Studio sent a campaign update.',
          'type': 'message',
          'data': {'room_id': 'chat-room-1'},
          'is_read': false,
          'created_at': '2026-06-26T09:22:00.000Z',
        },
        {
          'id': 'notification-2',
          'title': 'Package interest',
          'body': 'Pearl District Cafe viewed your launch campaign package.',
          'type': 'package_interest',
          'is_read': false,
          'created_at': '2026-06-25T16:10:00.000Z',
        },
        {
          'id': 'notification-3',
          'title': 'Offer activity',
          'body': 'Your cafe opening spotlight received new interest.',
          'type': 'offer_update',
          'is_read': true,
          'created_at': '2026-06-24T11:30:00.000Z',
        },
        {
          'id': 'notification-4',
          'title': 'Profile view',
          'body': 'Lina Atelier viewed your profile tools and packages.',
          'type': 'profile_view',
          'is_read': true,
          'created_at': '2026-06-23T14:05:00.000Z',
        },
      ];

  final List<Map<String, Object?>> _notifications;

  @override
  Future<NotificationsDto> fetchNotifications({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    return NotificationsDto.fromJsonFlexible(_notifications);
  }

  @override
  Future<void> markRead({
    required String? accessToken,
    required String id,
  }) async {
    for (final notification in _notifications) {
      if (notification['id'] == id) {
        notification['is_read'] = true;
      }
    }
  }

  @override
  Future<void> markAllRead({required String? accessToken}) async {
    for (final notification in _notifications) {
      notification['is_read'] = true;
    }
  }

  @override
  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  }) async {
    _notifications.removeWhere((notification) => notification['id'] == id);
  }

  @override
  Future<void> registerDeviceToken({
    required String? accessToken,
    required String token,
    String? deviceType,
  }) async {
    return;
  }
}
