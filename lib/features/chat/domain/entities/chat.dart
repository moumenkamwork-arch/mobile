enum ChatMessageStatus { sending, sent, delivered, read, failed, unknown }

extension ChatMessageStatusLabel on ChatMessageStatus {
  /// English-only fallback for non-UI use. For display, use
  /// `chatMessageStatusLabel(context, status)` instead.
  String get label {
    return switch (this) {
      ChatMessageStatus.sending => 'Sending',
      ChatMessageStatus.sent => 'Sent',
      ChatMessageStatus.delivered => 'Delivered',
      ChatMessageStatus.read => 'Read',
      ChatMessageStatus.failed => 'Failed',
      ChatMessageStatus.unknown => 'Unknown',
    };
  }

  static ChatMessageStatus fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'sending' => ChatMessageStatus.sending,
      'sent' => ChatMessageStatus.sent,
      'delivered' => ChatMessageStatus.delivered,
      'read' || 'is_read' => ChatMessageStatus.read,
      'failed' || 'error' => ChatMessageStatus.failed,
      _ => ChatMessageStatus.unknown,
    };
  }
}

class ChatParticipant {
  const ChatParticipant({
    required this.id,
    required this.displayName,
    this.username,
    this.avatarUrl,
    this.isVerified = false,
  });

  final String id;
  final String displayName;
  final String? username;
  final String? avatarUrl;
  final bool isVerified;

  String get initials {
    final words = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return 'P';
    }
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.sender,
    this.type = 'text',
    this.mediaUrl,
    this.isMine = false,
    this.status = ChatMessageStatus.unknown,
  });

  final String id;
  final String roomId;
  final String senderId;
  final ChatParticipant? sender;
  final String content;
  final String type;
  final String? mediaUrl;
  final DateTime createdAt;
  final bool isMine;
  final ChatMessageStatus status;

  bool get hasMedia => mediaUrl != null && mediaUrl!.trim().isNotEmpty;
}

class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.participant,
    this.lastMessage,
    this.unreadCount = 0,
    this.updatedAt,
    this.isNew = false,
  });

  final String id;
  final ChatParticipant participant;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime? updatedAt;
  final bool isNew;

  bool get hasUnread => unreadCount > 0;
}
