import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';
import 'package:promoo_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:promoo_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:promoo_app/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('chat list screen renders rooms', (tester) async {
    await tester.pumpWidget(
      _buildChatListScreen(_ChatRepository(rooms: [_room])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Saffron Social Studio'), findsOneWidget);
    expect(find.text('Launch plan ready'), findsOneWidget);
  });

  testWidgets('chat routes open list and conversation', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.chats);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatRepositoryProvider.overrideWithValue(
            _ChatRepository(rooms: [_room], messages: [_message]),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saffron Social Studio'));
    await tester.pumpAndSettle();

    expect(find.text('Conversation'), findsOneWidget);
    expect(find.text('Launch plan ready'), findsOneWidget);
  });

  testWidgets('chat room adds keyboard-aware input padding', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatRepositoryProvider.overrideWithValue(
            _ChatRepository(messages: [_message]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const MediaQuery(
            data: MediaQueryData(viewInsets: EdgeInsets.only(bottom: 280)),
            child: ChatRoomScreen(roomId: 'room-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final inputPadding = tester.widget<AnimatedPadding>(
      find.byType(AnimatedPadding).last,
    );
    expect(
      inputPadding.padding.resolve(TextDirection.ltr).bottom,
      greaterThan(280),
    );
    expect(find.widgetWithText(ElevatedButton, 'Send'), findsOneWidget);
  });
}

Widget _buildChatListScreen(ChatRepository repository) {
  return ProviderScope(
    overrides: [chatRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(theme: AppTheme.dark, home: const ChatListScreen()),
  );
}

const _participant = ChatParticipant(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
);

final _message = ChatMessage(
  id: 'message-1',
  roomId: 'room-1',
  senderId: 'profile-saffron-social',
  content: 'Launch plan ready',
  createdAt: DateTime(2026, 6, 26, 9, 20),
);

final _room = ChatRoom(
  id: 'room-1',
  participant: _participant,
  lastMessage: _message,
  unreadCount: 1,
);

class _ChatRepository implements ChatRepository {
  const _ChatRepository({this.rooms = const [], this.messages = const []});

  final List<ChatRoom> rooms;
  final List<ChatMessage> messages;

  @override
  Future<Result<List<ChatRoom>>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    return Result.success(rooms);
  }

  @override
  Future<Result<List<ChatMessage>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    return Result.success(messages);
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
    return Result.success(
      ChatMessage(
        id: 'sent-1',
        roomId: roomId,
        senderId: 'current-user',
        content: content,
        createdAt: DateTime(2026, 6, 26, 9, 21),
        isMine: true,
      ),
    );
  }

  @override
  Future<Result<ChatRoom>> startChat(String participantId) async {
    return Result.success(_room);
  }
}
