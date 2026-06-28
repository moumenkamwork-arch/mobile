import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';
import 'package:promoo_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:promoo_app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:promoo_app/features/chat/presentation/controllers/chat_room_controller.dart';

void main() {
  test('chat controller emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(
          _ChatRepository(roomsResult: Result.success([_room])),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(chatControllerProvider).status, ChatStatus.loading);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(chatControllerProvider);
    expect(state.status, ChatStatus.success);
    expect(state.rooms.single.participant.displayName, 'Saffron Social Studio');
  });

  test('chat controller emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(
          const _ChatRepository(
            roomsResult: Result.failure(
              AppFailure.unauthorized(message: 'Sign in'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(chatControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(chatControllerProvider);
    expect(state.status, ChatStatus.error);
    expect(state.isAuthRequired, isTrue);
  });

  test('room controller sends a text message', () async {
    final container = ProviderContainer(
      overrides: [
        chatRoomIdProvider.overrideWithValue('room-1'),
        chatRepositoryProvider.overrideWithValue(
          _ChatRepository(
            messagesResult: Result.success([_message]),
            sendResult: Result.success(_sentMessage),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(chatRoomControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(chatRoomControllerProvider.notifier)
        .sendText('Thanks');

    final state = container.read(chatRoomControllerProvider);
    expect(state.status, ChatRoomStatus.success);
    expect(state.messages.last.content, 'Thanks');
  });
}

const _participant = ChatParticipant(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
);

final _room = ChatRoom(
  id: 'room-1',
  participant: _participant,
  lastMessage: _message,
  unreadCount: 1,
);

final _message = ChatMessage(
  id: 'message-1',
  roomId: 'room-1',
  senderId: 'profile-1',
  content: 'Launch plan ready',
  createdAt: DateTime(2026, 6, 26, 9, 20),
  sender: _participant,
);

final _sentMessage = ChatMessage(
  id: 'message-2',
  roomId: 'room-1',
  senderId: 'current-user',
  content: 'Thanks',
  createdAt: DateTime(2026, 6, 26, 9, 21),
  isMine: true,
  status: ChatMessageStatus.sent,
);

class _ChatRepository implements ChatRepository {
  const _ChatRepository({
    this.roomsResult = const Result.success([]),
    this.messagesResult = const Result.success([]),
    this.sendResult = const Result.failure(AppFailure.unknown()),
  });

  final Result<List<ChatRoom>> roomsResult;
  final Result<List<ChatMessage>> messagesResult;
  final Result<ChatMessage> sendResult;

  @override
  Future<Result<List<ChatRoom>>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    return roomsResult;
  }

  @override
  Future<Result<List<ChatMessage>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    return messagesResult;
  }

  @override
  Future<Result<void>> markRoomRead(String roomId) async {
    return const Result.success(null);
  }

  @override
  Future<Result<ChatMessage>> sendMessage({
    required String roomId,
    required String content,
  }) async {
    return sendResult;
  }

  @override
  Future<Result<ChatRoom>> startChat(String participantId) async {
    return Result.success(_room);
  }
}
