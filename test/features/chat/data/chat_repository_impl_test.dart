import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/chat/data/datasources/chat_data_source.dart';
import 'package:promoo_app/features/chat/data/datasources/chat_fake_data_source.dart';
import 'package:promoo_app/features/chat/data/dto/chat_dto.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';

void main() {
  test('uses fake data source when mock fallback is enabled', () async {
    final repository = ChatRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
      ),
      remoteDataSource: _ThrowingChatDataSource(),
      fakeDataSource: ChatFakeDataSource(),
      sessionStore: InMemoryAuthSessionStore(),
    );

    final result = await repository.getRooms();

    expect(result.isSuccess, isTrue);
    result.when(
      success: (rooms) =>
          expect(rooms.first.participant.displayName, 'Saffron Social Studio'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('returns unauthorized in real mode without a session', () async {
    final repository = ChatRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingChatDataSource(),
      fakeDataSource: _ThrowingChatDataSource(),
      sessionStore: InMemoryAuthSessionStore(),
    );

    final result = await repository.getRooms();

    expect(result.isFailure, isTrue);
    result.when(
      success: (rooms) => fail('Expected failure, got $rooms'),
      failure: (failure) {
        expect(failure.type, AppFailureType.unauthorized);
        expect(failure.message, 'Sign in to use Promoo chat.');
      },
    );
  });

  test(
    'passes bearer token to remote data source when session exists',
    () async {
      final store = InMemoryAuthSessionStore();
      await store.write(_session);
      final remote = _RecordingChatDataSource();
      final repository = ChatRepositoryImpl(
        config: const AppConfig(
          environment: AppEnvironment.development,
          baseUrl: AppConfig.defaultDevelopmentBaseUrl,
          useMocks: false,
        ),
        remoteDataSource: remote,
        fakeDataSource: _ThrowingChatDataSource(),
        sessionStore: store,
      );

      final result = await repository.sendMessage(
        roomId: 'room-1',
        content: 'Hello',
      );

      expect(remote.lastAccessToken, 'access-1');
      result.when(
        success: (message) => expect(message.isMine, isTrue),
        failure: (failure) => fail('Expected success, got $failure'),
      );
    },
  );
}

const _session = AuthSession(
  user: AuthUser(id: 'current-user', email: 'alya@promoo.app'),
  tokens: AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
);

class _RecordingChatDataSource implements ChatDataSource {
  String? lastAccessToken;

  @override
  Future<ChatRoomsDto> fetchRooms({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    lastAccessToken = accessToken;
    return ChatRoomsDto.fromJsonFlexible([
      {
        'room': {'id': 'room-1'},
        'otherParticipant': {
          'id': 'profile-saffron-social',
          'full_name': 'Saffron Social Studio',
        },
      },
    ]);
  }

  @override
  Future<ChatMessagesDto> fetchMessages({
    required String? accessToken,
    required String roomId,
    int page = 1,
    int limit = 20,
  }) async {
    lastAccessToken = accessToken;
    return ChatMessagesDto.fromJsonFlexible([]);
  }

  @override
  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  }) async {
    lastAccessToken = accessToken;
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required String? accessToken,
    required String roomId,
    required String content,
  }) async {
    lastAccessToken = accessToken;
    return ChatMessageDto.fromJson({
      'id': 'message-1',
      'room_id': roomId,
      'sender_id': 'current-user',
      'content': content,
      'created_at': '2026-06-26T09:10:00Z',
    });
  }

  @override
  Future<ChatRoomDto> startChat({
    required String? accessToken,
    required String participantId,
  }) async {
    lastAccessToken = accessToken;
    return ChatRoomDto.fromJson({
      'room': {'id': 'room-1'},
      'participant': {'id': participantId, 'full_name': 'Promoo member'},
    });
  }
}

class _ThrowingChatDataSource implements ChatDataSource {
  const _ThrowingChatDataSource();

  static const _error = ApiException(
    type: ApiExceptionType.network,
    message: 'Unexpected call',
  );

  @override
  Future<ChatRoomsDto> fetchRooms({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) {
    return Future<ChatRoomsDto>.error(_error);
  }

  @override
  Future<ChatMessagesDto> fetchMessages({
    required String? accessToken,
    required String roomId,
    int page = 1,
    int limit = 20,
  }) {
    return Future<ChatMessagesDto>.error(_error);
  }

  @override
  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  }) {
    return Future<void>.error(_error);
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required String? accessToken,
    required String roomId,
    required String content,
  }) {
    return Future<ChatMessageDto>.error(_error);
  }

  @override
  Future<ChatRoomDto> startChat({
    required String? accessToken,
    required String participantId,
  }) {
    return Future<ChatRoomDto>.error(_error);
  }
}
