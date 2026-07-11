import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_data_source.dart';
import '../datasources/chat_fake_data_source.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    dataSource: ref.watch(chatFakeDataSourceProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
  );
});

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({
    required this.dataSource,
    required this.sessionStore,
  });

  final ChatDataSource dataSource;
  final AuthSessionStore sessionStore;

  @override
  Future<Result<List<ChatRoom>>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final auth = await _authContext();
      final dto = await dataSource.fetchRooms(
        accessToken: auth.accessToken,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain(currentUserId: auth.userId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<ChatRoom>> startChat(String participantId) async {
    try {
      final auth = await _authContext();
      final dto = await dataSource.startChat(
        accessToken: auth.accessToken,
        participantId: participantId,
      );
      final room = dto.toDomain(
        fallbackId: 'chat-$participantId',
        currentUserId: auth.userId,
      );
      if (room == null) {
        return const Result.failure(AppFailure.parsing());
      }
      return Result.success(room);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final auth = await _authContext();
      final dto = await dataSource.fetchMessages(
        accessToken: auth.accessToken,
        roomId: roomId,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain(currentUserId: auth.userId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage({
    required String roomId,
    required String content,
  }) async {
    try {
      final auth = await _authContext();
      final dto = await dataSource.sendMessage(
        accessToken: auth.accessToken,
        roomId: roomId,
        content: content,
      );
      final message = dto.toDomain(
        fallbackId: 'sent-${DateTime.now().microsecondsSinceEpoch}',
        fallbackRoomId: roomId,
        currentUserId: auth.userId,
      );
      if (message == null) {
        return const Result.failure(AppFailure.parsing());
      }
      return Result.success(message);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> markRoomRead(String roomId) async {
    try {
      final auth = await _authContext();
      await dataSource.markRoomRead(
        accessToken: auth.accessToken,
        roomId: roomId,
      );
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  Future<_AuthContext> _authContext() async {
    final session = await sessionStore.read();
    return _AuthContext(
      accessToken: session?.tokens?.accessToken,
      userId: session?.user.id,
    );
  }
}

class _AuthContext {
  const _AuthContext({this.accessToken, this.userId});

  final String? accessToken;
  final String? userId;
}
