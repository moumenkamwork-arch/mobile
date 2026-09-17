import '../../domain/entities/app_notification.dart';

class NotificationsDto {
  const NotificationsDto({required this.notifications});

  final List<AppNotificationDto> notifications;

  factory NotificationsDto.empty() {
    return const NotificationsDto(notifications: []);
  }

  factory NotificationsDto.fromJsonFlexible(Object? value) {
    return _fromData(value);
  }

  List<AppNotification> toDomain() {
    final mapped = <AppNotification>[];
    for (var i = 0; i < notifications.length; i++) {
      final notification = notifications[i].toDomain(
        fallbackId: 'notification-$i',
      );
      if (notification != null) {
        mapped.add(notification);
      }
    }
    return mapped;
  }

  static NotificationsDto _fromData(Object? value) {
    final map = _mapFrom(value);
    if (map != null) {
      final data = map['data'];
      final hasEnvelope =
          map.containsKey('success') ||
          map.containsKey('message') ||
          map.containsKey('meta');
      if (hasEnvelope && data != null) {
        return _fromData(data);
      }

      if (data is List) {
        return NotificationsDto(notifications: _parseList(data));
      }

      final nestedList = _firstListFrom(map, const [
        'notifications',
        'items',
        'records',
        'results',
      ]);
      if (nestedList != null) {
        return NotificationsDto(notifications: _parseList(nestedList));
      }

      final notification = AppNotificationDto.fromJson(map);
      if (notification.hasAnyContent) {
        return NotificationsDto(notifications: [notification]);
      }
    }

    if (value is List) {
      return NotificationsDto(notifications: _parseList(value));
    }

    return NotificationsDto.empty();
  }

  static List<AppNotificationDto> _parseList(List value) {
    final notifications = <AppNotificationDto>[];
    for (final item in value) {
      final map = _mapFrom(item);
      if (map != null) {
        final notification = AppNotificationDto.fromJson(map);
        if (notification.hasAnyContent) {
          notifications.add(notification);
        }
      }
    }
    return notifications;
  }
}

class AppNotificationDto {
  const AppNotificationDto({
    this.id,
    this.title,
    this.body,
    this.type = NotificationType.unknown,
    this.createdAt,
    this.isRead = false,
    this.data = const {},
  });

  final String? id;
  final String? title;
  final String? body;
  final NotificationType type;
  final DateTime? createdAt;
  final bool isRead;
  final Map<String, Object?> data;

  bool get hasAnyContent => id != null || title != null || body != null;

  factory AppNotificationDto.fromJson(Map<String, Object?> json) {
    final data = _mapFrom(json['data']) ?? <String, Object?>{};
    final roomId = _readString(json, const ['room_id', 'roomId']);
    if (roomId != null && !data.containsKey('room_id')) {
      data['room_id'] = roomId;
    }

    return AppNotificationDto(
      id: _readString(json, const ['id', 'notification_id', 'notificationId']),
      title: _readString(json, const ['title', 'headline']) ?? 'Promoo',
      body: _readString(json, const ['body', 'message', 'description']) ?? '',
      type: NotificationTypeValue.fromValue(
        _readString(json, const ['type', 'notification_type']),
      ),
      createdAt: _readDateTime(json, const ['created_at', 'createdAt']),
      isRead: _readBool(json, const ['is_read', 'isRead', 'read']),
      data: data,
    );
  }

  AppNotification? toDomain({required String fallbackId}) {
    final resolvedTitle = title?.trim();
    final resolvedBody = body?.trim();
    if ((resolvedTitle == null || resolvedTitle.isEmpty) &&
        (resolvedBody == null || resolvedBody.isEmpty)) {
      return null;
    }

    return AppNotification(
      id: id ?? fallbackId,
      title: resolvedTitle == null || resolvedTitle.isEmpty
          ? type.label
          : resolvedTitle,
      body: resolvedBody ?? '',
      type: type,
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      isRead: isRead,
      data: data,
    );
  }
}

List? _firstListFrom(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is List) {
      return value;
    }
  }
  return null;
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return Map<String, Object?>.from(value);
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

bool _readBool(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return false;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }
  }
  return false;
}

DateTime? _readDateTime(Map<String, Object?>? map, List<String> keys) {
  final value = _readString(map, keys);
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value);
}
