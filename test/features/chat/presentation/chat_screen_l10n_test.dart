import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';
import 'package:promoo_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:promoo_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:promoo_app/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'chat list screen renders Arabic header and empty state, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        _arabicApp(
          overrides: [
            chatRepositoryProvider.overrideWithValue(const _ChatRepository()),
          ],
          home: const ChatListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المحادثات'), findsOneWidget);
      expect(find.text('أبقِ محادثات حملاتك في مكان واحد.'), findsOneWidget);
      expect(find.text('لا توجد محادثات بعد'), findsOneWidget);
      expect(find.text('ستظهر محادثاتك هنا.'), findsOneWidget);

      expect(
        Directionality.of(tester.element(find.text('المحادثات'))),
        TextDirection.ltr,
      );
    },
  );

  testWidgets(
    'chat room screen renders Arabic conversation title and message status, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        _arabicApp(
          overrides: [
            chatRepositoryProvider.overrideWithValue(
              _ChatRepository(messages: [_deliveredMessage]),
            ),
          ],
          home: const ChatRoomScreen(roomId: 'room-1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المحادثة'), findsOneWidget);
      expect(find.textContaining('وصلت'), findsOneWidget);

      expect(
        Directionality.of(tester.element(find.text('المحادثة'))),
        TextDirection.ltr,
      );
    },
  );
}

Widget _arabicApp({
  required List<Override> overrides,
  required Widget home,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Mirrors lib/app.dart: translate, don't mirror the layout.
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Scaffold(body: home),
    ),
  );
}

final _deliveredMessage = ChatMessage(
  id: 'message-1',
  roomId: 'room-1',
  senderId: 'current-user',
  content: 'Launch plan ready',
  createdAt: DateTime(2026, 6, 26, 9, 20),
  isMine: true,
  status: ChatMessageStatus.delivered,
);

class _ChatRepository implements ChatRepository {
  const _ChatRepository({this.messages = const []});

  final List<ChatMessage> messages;

  @override
  Future<Result<List<ChatRoom>>> getRooms({int page = 1, int limit = 20}) async {
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
    return Result.success(_deliveredMessage);
  }

  @override
  Future<Result<ChatRoom>> startChat(String participantId) async {
    return const Result.failure(AppFailure.unknown(message: 'Not used'));
  }
}
