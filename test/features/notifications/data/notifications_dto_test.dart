import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/notifications/data/dto/notifications_dto.dart';
import 'package:promoo_app/features/notifications/domain/entities/app_notification.dart';

void main() {
  test('parses backend notifications list response', () {
    final dto = NotificationsDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'notification-1',
          'title': 'New message',
          'body': 'Saffron Social Studio sent a campaign update.',
          'type': 'message',
          'data': {'room_id': 'room-1'},
          'is_read': false,
          'created_at': '2026-06-26T09:22:00Z',
        },
      ],
      'meta': {'page': 1},
    });

    final notifications = dto.toDomain();

    expect(notifications.single.id, 'notification-1');
    expect(notifications.single.type, NotificationType.message);
    expect(notifications.single.isUnread, isTrue);
    expect(notifications.single.roomId, 'room-1');
  });

  test('parses direct notification and root room id variants', () {
    final dto = NotificationsDto.fromJsonFlexible({
      'id': 'notification-2',
      'title': 'System',
      'body': 'Welcome',
      'type': 'system',
      'roomId': 'room-2',
      'read': true,
    });

    final notification = dto.toDomain().single;

    expect(notification.type, NotificationType.system);
    expect(notification.isRead, isTrue);
    expect(notification.roomId, 'room-2');
  });
}
