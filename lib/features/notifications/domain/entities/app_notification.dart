enum NotificationType { follow, message, offer, system, payment, unknown }

extension NotificationTypeValue on NotificationType {
  static NotificationType fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'follow' => NotificationType.follow,
      'message' || 'chat' => NotificationType.message,
      'offer' => NotificationType.offer,
      'system' => NotificationType.system,
      'payment' => NotificationType.payment,
      _ => NotificationType.unknown,
    };
  }

  String get label {
    return switch (this) {
      NotificationType.follow => 'Follow',
      NotificationType.message => 'Message',
      NotificationType.offer => 'Offer',
      NotificationType.system => 'System',
      NotificationType.payment => 'Payment',
      NotificationType.unknown => 'Notification',
    };
  }
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data = const {},
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, Object?> data;

  bool get isUnread => !isRead;

  String? get roomId {
    final value = data['room_id'] ?? data['roomId'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }
}
