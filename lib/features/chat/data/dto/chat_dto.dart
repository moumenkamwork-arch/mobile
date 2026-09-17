import '../../domain/entities/chat.dart';

class ChatRoomsDto {
  const ChatRoomsDto({required this.rooms});

  final List<ChatRoomDto> rooms;

  factory ChatRoomsDto.empty() {
    return const ChatRoomsDto(rooms: []);
  }

  factory ChatRoomsDto.fromJsonFlexible(Object? value) {
    return _fromData(value);
  }

  List<ChatRoom> toDomain({String? currentUserId}) {
    final mapped = <ChatRoom>[];
    for (var i = 0; i < rooms.length; i++) {
      final room = rooms[i].toDomain(
        fallbackId: 'chat-room-$i',
        currentUserId: currentUserId,
      );
      if (room != null) {
        mapped.add(room);
      }
    }
    return mapped;
  }

  static ChatRoomsDto _fromData(Object? value) {
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
        return ChatRoomsDto(rooms: _parseRooms(data));
      }

      final nestedList = _firstListFrom(map, const [
        'rooms',
        'chats',
        'items',
        'records',
        'results',
      ]);
      if (nestedList != null) {
        return ChatRoomsDto(rooms: _parseRooms(nestedList));
      }

      final room = ChatRoomDto.fromJson(map);
      if (room.hasAnyIdentity) {
        return ChatRoomsDto(rooms: [room]);
      }
    }

    if (value is List) {
      return ChatRoomsDto(rooms: _parseRooms(value));
    }

    return ChatRoomsDto.empty();
  }

  static List<ChatRoomDto> _parseRooms(List items) {
    final rooms = <ChatRoomDto>[];
    for (final item in items) {
      final map = _mapFrom(item);
      if (map != null) {
        final room = ChatRoomDto.fromJson(map);
        if (room.hasAnyIdentity) {
          rooms.add(room);
        }
      }
    }
    return rooms;
  }
}

class ChatRoomDto {
  const ChatRoomDto({
    this.id,
    this.participant,
    this.lastMessage,
    this.unreadCount = 0,
    this.updatedAt,
    this.isNew = false,
  });

  final String? id;
  final ChatParticipantDto? participant;
  final ChatMessageDto? lastMessage;
  final int unreadCount;
  final DateTime? updatedAt;
  final bool isNew;

  bool get hasAnyIdentity => id != null || participant != null;

  factory ChatRoomDto.fromJson(Map<String, Object?> json) {
    final room = _mapFrom(json['room']) ?? json;
    final participant = _firstMapFrom(json, const [
      'otherParticipant',
      'other_participant',
      'participant',
      'profile',
      'user',
    ]);
    final lastMessage = _firstMapFrom(json, const [
      'lastMessage',
      'last_message',
      'message',
    ]);
    final id =
        _readString(room, const ['id', 'room_id', 'roomId']) ??
        _readString(json, const ['room_id', 'roomId']);

    return ChatRoomDto(
      id: id,
      participant: participant == null
          ? null
          : ChatParticipantDto.fromJson(participant),
      lastMessage: lastMessage == null
          ? null
          : ChatMessageDto.fromJson(lastMessage, fallbackRoomId: id),
      unreadCount:
          _readInt(json, const ['unreadCount', 'unread_count']) ??
          _readInt(room, const ['unreadCount', 'unread_count']) ??
          0,
      updatedAt:
          _readDateTime(room, const ['last_message_at', 'updated_at']) ??
          _readDateTime(json, const ['last_message_at', 'updated_at']),
      isNew: _readBool(json, const ['isNew', 'is_new']),
    );
  }

  ChatRoom? toDomain({required String fallbackId, String? currentUserId}) {
    final resolvedId = id ?? fallbackId;
    final resolvedParticipant = participant?.toDomain(
      fallbackId: '$resolvedId-participant',
    );
    if (resolvedParticipant == null) {
      return null;
    }

    return ChatRoom(
      id: resolvedId,
      participant: resolvedParticipant,
      lastMessage: lastMessage?.toDomain(
        fallbackId: '$resolvedId-last-message',
        fallbackRoomId: resolvedId,
        currentUserId: currentUserId,
      ),
      unreadCount: unreadCount,
      updatedAt: updatedAt,
      isNew: isNew,
    );
  }
}

class ChatMessagesDto {
  const ChatMessagesDto({required this.messages});

  final List<ChatMessageDto> messages;

  factory ChatMessagesDto.empty() {
    return const ChatMessagesDto(messages: []);
  }

  factory ChatMessagesDto.fromJsonFlexible(Object? value) {
    return _fromData(value);
  }

  List<ChatMessage> toDomain({String? currentUserId}) {
    final mapped = <ChatMessage>[];
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i].toDomain(
        fallbackId: 'chat-message-$i',
        currentUserId: currentUserId,
      );
      if (message != null) {
        mapped.add(message);
      }
    }
    mapped.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return mapped;
  }

  static ChatMessagesDto _fromData(Object? value) {
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
        return ChatMessagesDto(messages: _parseMessages(data));
      }

      final nestedList = _firstListFrom(map, const [
        'messages',
        'items',
        'records',
        'results',
      ]);
      if (nestedList != null) {
        return ChatMessagesDto(messages: _parseMessages(nestedList));
      }

      final message = ChatMessageDto.fromJson(map);
      if (message.hasContentOrIdentity) {
        return ChatMessagesDto(messages: [message]);
      }
    }

    if (value is List) {
      return ChatMessagesDto(messages: _parseMessages(value));
    }

    return ChatMessagesDto.empty();
  }

  static List<ChatMessageDto> _parseMessages(List items) {
    final messages = <ChatMessageDto>[];
    for (final item in items) {
      final map = _mapFrom(item);
      if (map != null) {
        final message = ChatMessageDto.fromJson(map);
        if (message.hasContentOrIdentity) {
          messages.add(message);
        }
      }
    }
    return messages;
  }
}

class ChatMessageDto {
  const ChatMessageDto({
    this.id,
    this.roomId,
    this.senderId,
    this.sender,
    this.content,
    this.type = 'text',
    this.mediaUrl,
    this.createdAt,
    this.isMine,
    this.status,
    this.isRead = false,
  });

  final String? id;
  final String? roomId;
  final String? senderId;
  final ChatParticipantDto? sender;
  final String? content;
  final String type;
  final String? mediaUrl;
  final DateTime? createdAt;
  final bool? isMine;
  final ChatMessageStatus? status;
  final bool isRead;

  bool get hasContentOrIdentity => id != null || content != null;

  factory ChatMessageDto.fromJson(
    Map<String, Object?> json, {
    String? fallbackRoomId,
  }) {
    final sender = _firstMapFrom(json, const ['sender', 'profile', 'user']);
    final isRead = _readBool(json, const ['is_read', 'isRead']);

    return ChatMessageDto(
      id: _readString(json, const ['id', 'message_id', 'messageId']),
      roomId:
          _readString(json, const ['room_id', 'roomId', 'chat_room_id']) ??
          fallbackRoomId,
      senderId:
          _readString(json, const ['sender_id', 'senderId', 'profile_id']) ??
          _readString(sender, const ['id']),
      sender: sender == null ? null : ChatParticipantDto.fromJson(sender),
      content: _readString(json, const ['content', 'body', 'text', 'message']),
      type:
          _readString(json, const ['type', 'message_type', 'messageType']) ??
          'text',
      mediaUrl: _readString(json, const ['media_url', 'mediaUrl', 'url']),
      createdAt: _readDateTime(json, const ['created_at', 'createdAt']),
      isMine: _readNullableBool(json, const ['is_mine', 'isMine']),
      status: isRead
          ? ChatMessageStatus.read
          : ChatMessageStatusLabel.fromValue(
              _readString(json, const ['status']),
            ),
      isRead: isRead,
    );
  }

  ChatMessage? toDomain({
    required String fallbackId,
    String? fallbackRoomId,
    String? currentUserId,
  }) {
    final resolvedRoomId = roomId ?? fallbackRoomId;
    final resolvedSenderId = senderId ?? sender?.id;
    if (resolvedRoomId == null || resolvedSenderId == null) {
      return null;
    }

    final resolvedType = type.trim().isEmpty ? 'text' : type.trim();
    final resolvedContent = _messageContent(content, resolvedType, mediaUrl);

    return ChatMessage(
      id: id ?? fallbackId,
      roomId: resolvedRoomId,
      senderId: resolvedSenderId,
      sender: sender?.toDomain(fallbackId: resolvedSenderId),
      content: resolvedContent,
      type: resolvedType,
      mediaUrl: mediaUrl,
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      isMine:
          isMine ??
          (currentUserId != null && resolvedSenderId == currentUserId),
      status: status == ChatMessageStatus.unknown && isRead
          ? ChatMessageStatus.read
          : (status ?? ChatMessageStatus.unknown),
    );
  }
}

class ChatParticipantDto {
  const ChatParticipantDto({
    this.id,
    this.displayName,
    this.username,
    this.avatarUrl,
    this.isVerified = false,
  });

  final String? id;
  final String? displayName;
  final String? username;
  final String? avatarUrl;
  final bool isVerified;

  factory ChatParticipantDto.fromJson(Map<String, Object?> json) {
    return ChatParticipantDto(
      id: _readString(json, const ['id', 'profile_id', 'participant_id']),
      displayName: _readString(json, const [
        'full_name',
        'display_name',
        'name',
        'username',
      ]),
      username: _readString(json, const ['username']),
      avatarUrl: _readString(json, const ['avatar_url', 'avatarUrl']),
      isVerified: _readBool(json, const ['is_verified', 'isVerified']),
    );
  }

  ChatParticipant? toDomain({required String fallbackId}) {
    final resolvedName = displayName ?? username;
    if (resolvedName == null || resolvedName.trim().isEmpty) {
      return null;
    }

    return ChatParticipant(
      id: id ?? fallbackId,
      displayName: resolvedName,
      username: username,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
    );
  }
}

String _messageContent(String? content, String type, String? mediaUrl) {
  if (content != null && content.trim().isNotEmpty) {
    return content.trim();
  }
  if (mediaUrl != null && mediaUrl.trim().isNotEmpty) {
    return type == 'text' ? 'Sent an attachment' : 'Sent a $type';
  }
  return type == 'text' ? '' : 'Sent a $type';
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

Map<String, Object?>? _firstMapFrom(
  Map<String, Object?> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = _mapFrom(map[key]);
    if (value != null) {
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
    return value;
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

int? _readInt(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
  }
  return null;
}

bool _readBool(Map<String, Object?>? map, List<String> keys) {
  return _readNullableBool(map, keys) ?? false;
}

bool? _readNullableBool(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
  }
  return null;
}

DateTime? _readDateTime(Map<String, Object?>? map, List<String> keys) {
  final value = _readString(map, keys);
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value);
}
