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
            'id': 'profile-saffron-social',
            'full_name': 'Saffron Social Studio',
            'avatar_url': 'https://example.com/avatar.png',
          },
          'lastMessage': {
            'id': 'message-1',
            'room_id': 'room-1',
            'sender_id': 'profile-saffron-social',
            'content': 'Launch plan ready',
            'type': 'text',
            'created_at': '2026-06-26T09:20:00Z',
          },
          'unreadCount': 2,
        },
      ],
      'meta': {'page': 1},
    });

    final rooms = dto.toDomain(currentUserId: 'current-user');

    expect(rooms.single.id, 'room-1');
    expect(rooms.single.participant.displayName, 'Saffron Social Studio');
    expect(rooms.single.unreadCount, 2);
    expect(rooms.single.lastMessage?.content, 'Launch plan ready');
  });

  test('parses messages and marks current user messages as mine', () {
    final dto = ChatMessagesDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'message-1',
          'room_id': 'room-1',
          'sender_id': 'current-user',
          'content': 'Hello',
          'type': 'text',
          'created_at': '2026-06-26T09:10:00Z',
          'is_read': true,
        },
        {
          'id': 'message-2',
          'room_id': 'room-1',
          'sender': {
            'id': 'profile-saffron-social',
            'full_name': 'Saffron Social Studio',
          },
          'content': 'Welcome, we can help with the launch plan.',
          'created_at': '2026-06-26T09:12:00Z',
        },
      ],
    });

    final messages = dto.toDomain(currentUserId: 'current-user');

    expect(messages, hasLength(2));
    expect(messages.first.isMine, isTrue);
    expect(messages.first.status, ChatMessageStatus.read);
    expect(messages.last.sender?.displayName, 'Saffron Social Studio');
  });
}
