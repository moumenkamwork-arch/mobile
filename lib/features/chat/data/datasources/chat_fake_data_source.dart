import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/chat_dto.dart';
import 'chat_data_source.dart';

final chatFakeDataSourceProvider = Provider<ChatFakeDataSource>((ref) {
  return ChatFakeDataSource();
});

class ChatFakeDataSource implements ChatDataSource {
  ChatFakeDataSource()
    : _rooms = [
        {
          'room': {
            'id': 'chat-room-1',
            'last_message_at': '2026-06-26T09:20:00.000Z',
          },
          'otherParticipant': {
            'id': 'profile-saffron-social',
            'full_name': 'Saffron Social Studio',
            'username': 'saffron.social',
            'is_verified': true,
          },
          'lastMessage': {
            'id': 'message-2',
            'room_id': 'chat-room-1',
            'sender_id': 'profile-saffron-social',
            'content':
                'We can prepare the launch plan and creator options today.',
            'type': 'text',
            'created_at': '2026-06-26T09:20:00.000Z',
            'is_read': false,
          },
          'unreadCount': 2,
        },
        {
          'room': {
            'id': 'chat-room-2',
            'last_message_at': '2026-06-25T17:40:00.000Z',
          },
          'otherParticipant': {
            'id': 'profile-framehouse',
            'full_name': 'Framehouse Events',
            'username': 'framehouse.events',
          },
          'lastMessage': {
            'id': 'message-4',
            'room_id': 'chat-room-2',
            'sender_id': 'current-user',
            'content': 'Thanks, I will confirm the preferred shoot window.',
            'type': 'text',
            'created_at': '2026-06-25T17:40:00.000Z',
            'is_mine': true,
            'is_read': true,
          },
          'unreadCount': 0,
        },
      ],
      _messagesByRoom = {
        'chat-room-1': [
          {
            'id': 'message-1',
            'room_id': 'chat-room-1',
            'sender_id': 'current-user',
            'content':
                'Can you share availability for a cafe opening campaign next week?',
            'type': 'text',
            'created_at': '2026-06-26T09:10:00.000Z',
            'is_mine': true,
            'is_read': true,
          },
          {
            'id': 'message-2',
            'room_id': 'chat-room-1',
            'sender_id': 'profile-saffron-social',
            'sender': {
              'id': 'profile-saffron-social',
              'full_name': 'Saffron Social Studio',
              'username': 'saffron.social',
              'is_verified': true,
            },
            'content':
                'We can prepare the launch plan and creator options today.',
            'type': 'text',
            'created_at': '2026-06-26T09:20:00.000Z',
            'is_read': false,
          },
        ],
        'chat-room-2': [
          {
            'id': 'message-3',
            'room_id': 'chat-room-2',
            'sender_id': 'profile-framehouse',
            'sender': {
              'id': 'profile-framehouse',
              'full_name': 'Framehouse Events',
              'username': 'framehouse.events',
            },
            'content':
                'We have two available photography slots for product visuals.',
            'type': 'text',
            'created_at': '2026-06-25T17:32:00.000Z',
            'is_read': true,
          },
          {
            'id': 'message-4',
            'room_id': 'chat-room-2',
            'sender_id': 'current-user',
            'content': 'Thanks, I will confirm the preferred shoot window.',
            'type': 'text',
            'created_at': '2026-06-25T17:40:00.000Z',
            'is_mine': true,
            'is_read': true,
          },
        ],
      };

  final List<Map<String, Object?>> _rooms;
  final Map<String, List<Map<String, Object?>>> _messagesByRoom;

  @override
  Future<ChatRoomsDto> fetchRooms({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    return ChatRoomsDto.fromJsonFlexible(_rooms);
  }

  @override
  Future<ChatRoomDto> startChat({
    required String? accessToken,
    required String participantId,
  }) async {
    final existing = _rooms.firstWhere((room) {
      final participant = room['otherParticipant'];
      return participant is Map && participant['id'] == participantId;
    }, orElse: () => const {});
    if (existing.isNotEmpty) {
      return ChatRoomDto.fromJson(existing);
    }

    final roomId = 'chat-room-${_rooms.length + 1}';
    final room = {
      'room': {
        'id': roomId,
        'last_message_at': DateTime.now().toIso8601String(),
      },
      'otherParticipant': {'id': participantId, 'full_name': 'Promoo member'},
      'unreadCount': 0,
      'isNew': true,
    };
    _rooms.insert(0, room);
    _messagesByRoom[roomId] = [];
    return ChatRoomDto.fromJson(room);
  }

  @override
  Future<ChatMessagesDto> fetchMessages({
    required String? accessToken,
    required String roomId,
    int page = 1,
    int limit = 20,
  }) async {
    return ChatMessagesDto.fromJsonFlexible(_messagesByRoom[roomId] ?? []);
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required String? accessToken,
    required String roomId,
    required String content,
  }) async {
    final messages = _messagesByRoom.putIfAbsent(roomId, () => []);
    final message = {
      'id': 'message-${DateTime.now().microsecondsSinceEpoch}',
      'room_id': roomId,
      'sender_id': 'current-user',
      'content': content,
      'type': 'text',
      'created_at': DateTime.now().toIso8601String(),
      'is_mine': true,
      'status': 'sent',
    };
    messages.add(message);
    return ChatMessageDto.fromJson(message);
  }

  @override
  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  }) async {
    for (final room in _rooms) {
      final roomMap = room['room'];
      if (roomMap is Map && roomMap['id'] == roomId) {
        room['unreadCount'] = 0;
      }
    }
  }
}
