import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/chat/data/dto/chat_dto.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';

void main() {
  test('parses backend chat list response', () {
    final dto = ChatRoomsDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'room': {'id': 'room-1', 'last_message_at': '2026-06-26T09:20:00Z'},
          'otherParticipant': {
            'id': 'profile-1',
            'full_name': 'Noura Studio',
            'avatar_url': 'https://example.com/avatar.png',
          },
          'lastMessage': {
            'id': 'message-1',
            'room_id': 'room-1',
            'sender_id': 'profile-1',
            'content': 'Brief ready',
            'type': 'text',
            'created_at': '2026-06-26T09:20:00Z',
          },
          'unreadCount': 2,
        },
      ],
      'meta': {'page': 1},
    });

    final rooms = dto.toDomain(currentUserId: 'demo-user');

    expect(rooms.single.id, 'room-1');
    expect(rooms.single.participant.displayName, 'Noura Studio');
    expect(rooms.single.unreadCount, 2);
    expect(rooms.single.lastMessage?.content, 'Brief ready');
  });

  test('parses messages and marks current user messages as mine', () {
    final dto = ChatMessagesDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'message-1',
          'room_id': 'room-1',
          'sender_id': 'demo-user',
          'content': 'Hello',
          'type': 'text',
          'created_at': '2026-06-26T09:10:00Z',
          'is_read': true,
        },
        {
          'id': 'message-2',
          'room_id': 'room-1',
          'sender': {'id': 'profile-1', 'full_name': 'Noura Studio'},
          'content': 'Welcome',
          'created_at': '2026-06-26T09:12:00Z',
        },
      ],
    });

    final messages = dto.toDomain(currentUserId: 'demo-user');

    expect(messages, hasLength(2));
    expect(messages.first.isMine, isTrue);
    expect(messages.first.status, ChatMessageStatus.read);
    expect(messages.last.sender?.displayName, 'Noura Studio');
  });
}
