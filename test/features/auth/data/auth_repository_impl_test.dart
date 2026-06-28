import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:promoo_app/features/auth/data/datasources/auth_fake_data_source.dart';
import 'package:promoo_app/features/auth/data/dto/auth_dto.dart';
import 'package:promoo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';

void main() {
  test(
    'uses fake data source and stores session when mocks are enabled',
    () async {
      final store = InMemoryAuthSessionStore();
      final repository = AuthRepositoryImpl(
        config: const AppConfig(
          environment: AppEnvironment.development,
          baseUrl: AppConfig.defaultDevelopmentBaseUrl,
          useMocks: true,
        ),
        remoteDataSource: _ThrowingDataSource(),
        fakeDataSource: const AuthFakeDataSource(),
        sessionStore: store,
      );

      final result = await repository.loginWithEmail(
        email: 'alya@promoo.app',
        password: 'password123',
      );

      expect(result.isSuccess, isTrue);
      expect((await store.read())?.isAuthenticated, isTrue);
    },
  );

  test('uses remote data source when mocks are disabled', () async {
    final store = InMemoryAuthSessionStore();
    final remoteDataSource = _RecordingDataSource(
      dto: _sessionDto(email: 'remote@promoo.app'),
    );
    final repository = AuthRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
      sessionStore: store,
    );

    final result = await repository.registerWithEmail(
      fullName: 'Remote User',
      email: 'remote@promoo.app',
      password: 'password123',
      accountType: AuthAccountType.influencer,
    );

    expect(
      remoteDataSource.lastRegisterAccountType,
      AuthAccountType.influencer,
    );
    result.when(
      success: (session) => expect(session.user.email, 'remote@promoo.app'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('maps API exceptions to failures', () async {
    final repository = AuthRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.unauthorized,
          message: 'Invalid credentials',
        ),
      ),
      fakeDataSource: _ThrowingDataSource(),
      sessionStore: InMemoryAuthSessionStore(),
    );

    final result = await repository.loginWithEmail(
      email: 'alya@promoo.app',
      password: 'fail',
    );

    expect(result.isFailure, isTrue);
    result.when(
      success: (session) => fail('Expected failure, got $session'),
      failure: (failure) => expect(failure.message, 'Invalid credentials'),
    );
  });

  test('logout clears in-memory session', () async {
    final store = InMemoryAuthSessionStore();
    await store.write(_session);
    final remoteDataSource = _RecordingDataSource(dto: _sessionDto());
    final repository = AuthRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
      sessionStore: store,
    );

    final result = await repository.logout();

    expect(result.isSuccess, isTrue);
    expect(remoteDataSource.lastLogoutAccessToken, 'access-1');
    expect(await store.read(), isNull);
  });
}

AuthSessionDto _sessionDto({String email = 'alya@promoo.app'}) {
  return AuthSessionDto.fromJsonFlexible({
    'user': {
      'id': 'user-1',
      'email': email,
      'user_metadata': {'full_name': 'Alya Hassan'},
    },
    'session': {'access_token': 'access-1', 'refresh_token': 'refresh-1'},
  });
}

const _session = AuthSession(
  user: AuthUser(id: 'user-1', email: 'alya@promoo.app'),
  tokens: AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
);

class _RecordingDataSource implements AuthDataSource {
  _RecordingDataSource({required this.dto});

  final AuthSessionDto dto;
  AuthAccountType? lastRegisterAccountType;
  String? lastLogoutAccessToken;

  @override
  Future<AuthSessionDto> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return dto;
  }

  @override
  Future<AuthSessionDto> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    lastRegisterAccountType = accountType;
    return dto;
  }

  @override
  Future<AuthSessionDto> refreshSession({required String refreshToken}) async {
    return dto;
  }

  @override
  Future<void> logout({String? accessToken}) async {
    lastLogoutAccessToken = accessToken;
  }
}

class _ThrowingDataSource implements AuthDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<AuthSessionDto> loginWithEmail({
    required String email,
    required String password,
  }) {
    return Future<AuthSessionDto>.error(error);
  }

  @override
  Future<AuthSessionDto> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) {
    return Future<AuthSessionDto>.error(error);
  }

  @override
  Future<AuthSessionDto> refreshSession({required String refreshToken}) {
    return Future<AuthSessionDto>.error(error);
  }

  @override
  Future<void> logout({String? accessToken}) {
    return Future<void>.error(error);
  }
}
