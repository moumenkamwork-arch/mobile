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

  /// English-only fallback for non-UI use. For display, use
  /// `notificationTypeLabel(context, type)` instead.
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

  /// Chat room to open when a message notification is tapped.
  String? get roomId => _stringData(const ['room_id', 'roomId']);

  /// The profile to open when a follow notification is tapped — the person who
  /// started following you (`data.follower_id`), or a generic `profile_id`.
  String? get profileId =>
      _stringData(const ['follower_id', 'followerId', 'profile_id', 'profileId']);

  String? _stringData(List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
