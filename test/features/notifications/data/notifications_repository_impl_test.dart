import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/notifications/data/datasources/notifications_data_source.dart';
import 'package:promoo_app/features/notifications/data/datasources/notifications_fake_data_source.dart';
import 'package:promoo_app/features/notifications/data/dto/notifications_dto.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';

void main() {
  test('uses fake data source when mock fallback is enabled', () async {
    final repository = NotificationsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
      ),
      remoteDataSource: _ThrowingNotificationsDataSource(),
      fakeDataSource: NotificationsFakeDataSource(),
      sessionStore: InMemoryAuthSessionStore(),
    );

    final result = await repository.getNotifications();

    expect(result.isSuccess, isTrue);
    result.when(
      success: (notifications) =>
          expect(notifications.first.title, 'New message'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('returns unauthorized in real mode without a session', () async {
    final repository = NotificationsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingNotificationsDataSource(),
      fakeDataSource: _ThrowingNotificationsDataSource(),
      sessionStore: InMemoryAuthSessionStore(),
    );

    final result = await repository.getNotifications();

    result.when(
      success: (notifications) => fail('Expected failure, got $notifications'),
      failure: (failure) {
        expect(failure.type, AppFailureType.unauthorized);
        expect(failure.message, 'Sign in to view notifications.');
      },
    );
  });

  test('passes bearer token to remote mutations when session exists', () async {
    final store = InMemoryAuthSessionStore();
    await store.write(_session);
    final remote = _RecordingNotificationsDataSource();
    final repository = NotificationsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: remote,
      fakeDataSource: _ThrowingNotificationsDataSource(),
      sessionStore: store,
    );

    final result = await repository.markRead('notification-1');

    expect(result.isSuccess, isTrue);
    expect(remote.lastAccessToken, 'access-1');
    expect(remote.lastMarkedId, 'notification-1');
  });
}

const _session = AuthSession(
  user: AuthUser(id: 'demo-user', email: 'demo@promoo.app'),
  tokens: AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
);

class _RecordingNotificationsDataSource implements NotificationsDataSource {
  String? lastAccessToken;
  String? lastMarkedId;

  @override
  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  }) async {
    lastAccessToken = accessToken;
  }

  @override
  Future<NotificationsDto> fetchNotifications({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    lastAccessToken = accessToken;
    return NotificationsDto.fromJsonFlexible([]);
  }

  @override
  Future<void> markAllRead({required String? accessToken}) async {
    lastAccessToken = accessToken;
  }

  @override
  Future<void> markRead({
    required String? accessToken,
    required String id,
  }) async {
    lastAccessToken = accessToken;
    lastMarkedId = id;
  }

  @override
  Future<void> registerDeviceToken({
    required String? accessToken,
    required String token,
    String? deviceType,
  }) async {
    lastAccessToken = accessToken;
  }
}

class _ThrowingNotificationsDataSource implements NotificationsDataSource {
  const _ThrowingNotificationsDataSource();

  static const _error = ApiException(
    type: ApiExceptionType.network,
    message: 'Unexpected call',
  );

  @override
  Future<void> deleteNotification({
    required String? accessToken,
    required String id,
  }) {
    return Future<void>.error(_error);
  }

  @override
  Future<NotificationsDto> fetchNotifications({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) {
    return Future<NotificationsDto>.error(_error);
  }

  @override
  Future<void> markAllRead({required String? accessToken}) {
    return Future<void>.error(_error);
  }

  @override
  Future<void> markRead({required String? accessToken, required String id}) {
    return Future<void>.error(_error);
  }

  @override
  Future<void> registerDeviceToken({
    required String? accessToken,
    required String token,
    String? deviceType,
  }) {
    return Future<void>.error(_error);
  }
}
