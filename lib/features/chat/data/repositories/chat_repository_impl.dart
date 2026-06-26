import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_data_source.dart';
import '../datasources/chat_fake_data_source.dart';
import '../datasources/chat_remote_data_source.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(chatRemoteDataSourceProvider),
    fakeDataSource: ref.watch(chatFakeDataSourceProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
  );
});

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
    required this.sessionStore,
  });

  final AppConfig config;
  final ChatDataSource remoteDataSource;
  final ChatDataSource fakeDataSource;
  final AuthSessionStore sessionStore;

  ChatDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<List<ChatRoom>>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final auth = await _authContext();
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      final dto = await _activeDataSource.fetchRooms(
        accessToken: auth.accessToken,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain(currentUserId: auth.userId));
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      final dto = await _activeDataSource.startChat(
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
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      final dto = await _activeDataSource.fetchMessages(
        accessToken: auth.accessToken,
        roomId: roomId,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain(currentUserId: auth.userId));
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      final dto = await _activeDataSource.sendMessage(
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
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      await _activeDataSource.markRoomRead(
        accessToken: auth.accessToken,
        roomId: roomId,
      );
      return const Result.success(null);
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  Future<_AuthContext> _authContext() async {
    final session = await sessionStore.read();
    final accessToken = session?.tokens?.accessToken;
    if (!config.useMocks && (accessToken == null || accessToken.isEmpty)) {
      return const _AuthContext(
        failure: AppFailure.unauthorized(
          message: 'Sign in to use Promoo chat.',
        ),
      );
    }

    return _AuthContext(accessToken: accessToken, userId: session?.user.id);
  }
}

class _AuthContext {
  const _AuthContext({this.accessToken, this.userId, this.failure});

  final String? accessToken;
  final String? userId;
  final AppFailure? failure;
}
