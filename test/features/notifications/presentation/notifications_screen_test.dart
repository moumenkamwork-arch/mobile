import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';
import 'package:promoo_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:promoo_app/features/notifications/domain/entities/app_notification.dart';
import 'package:promoo_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:promoo_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('notifications screen renders notification cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildNotificationsScreen(
        _NotificationsRepository(notifications: [_notification]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('New message'), findsOneWidget);
    expect(find.text('Mark all read'), findsOneWidget);
  });

  testWidgets(
    'message notification route opens chat room when room id exists',
    (tester) async {
      final router = createAppRouter(initialLocation: AppRoutes.notifications);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationsRepositoryProvider.overrideWithValue(
              _NotificationsRepository(notifications: [_notification]),
            ),
            chatRepositoryProvider.overrideWithValue(
              _ChatRepository(messages: [_message]),
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('New message'));
      await tester.pumpAndSettle();

      expect(find.text('Conversation'), findsOneWidget);
      expect(find.text('Brief ready'), findsOneWidget);
    },
  );
}

Widget _buildNotificationsScreen(NotificationsRepository repository) {
  return ProviderScope(
    overrides: [notificationsRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(theme: AppTheme.dark, home: const NotificationsScreen()),
  );
}

final _notification = AppNotification(
  id: 'notification-1',
  title: 'New message',
  body: 'Noura Studio sent an update.',
  type: NotificationType.message,
  createdAt: DateTime(2026, 6, 26, 9, 22),
  data: const {'room_id': 'room-1'},
);

final _message = ChatMessage(
  id: 'message-1',
  roomId: 'room-1',
  senderId: 'profile-1',
  content: 'Brief ready',
  createdAt: DateTime(2026, 6, 26, 9, 20),
);

class _NotificationsRepository implements NotificationsRepository {
  const _NotificationsRepository({this.notifications = const []});

  final List<AppNotification> notifications;

  @override
  Future<Result<void>> deleteNotification(String id) async {
    return const Result.success(null);
  }

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    return Result.success(notifications);
  }

  @override
  Future<Result<void>> markAllRead() async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> markRead(String id) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> registerDeviceToken({
    required String token,
    String? deviceType,
  }) async {
    return const Result.success(null);
  }
}

class _ChatRepository implements ChatRepository {
  const _ChatRepository({this.messages = const []});

  final List<ChatMessage> messages;

  @override
  Future<Result<List<ChatRoom>>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    return const Result.success([]);
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
        senderId: 'demo-user',
        content: content,
        createdAt: DateTime(2026, 6, 26, 9, 21),
        isMine: true,
      ),
    );
  }

  @override
  Future<Result<ChatRoom>> startChat(String participantId) async {
    return Result.success(
      ChatRoom(
        id: 'room-1',
        participant: const ChatParticipant(
          id: 'profile-1',
          displayName: 'Noura Studio',
        ),
      ),
    );
  }
}
