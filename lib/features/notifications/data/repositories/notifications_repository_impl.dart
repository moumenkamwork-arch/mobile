import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_data_source.dart';
import '../datasources/notifications_fake_data_source.dart';
import '../datasources/notifications_remote_data_source.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(notificationsRemoteDataSourceProvider),
    fakeDataSource: ref.watch(notificationsFakeDataSourceProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
  );
});

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
    required this.sessionStore,
  });

  final AppConfig config;
  final NotificationsDataSource remoteDataSource;
  final NotificationsDataSource fakeDataSource;
  final AuthSessionStore sessionStore;

  NotificationsDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final auth = await _authContext();
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      final dto = await _activeDataSource.fetchNotifications(
        accessToken: auth.accessToken,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain());
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> markRead(String id) {
    return _mutate(
      (accessToken) =>
          _activeDataSource.markRead(accessToken: accessToken, id: id),
    );
  }

  @override
  Future<Result<void>> markAllRead() {
    return _mutate(
      (accessToken) => _activeDataSource.markAllRead(accessToken: accessToken),
    );
  }

  @override
  Future<Result<void>> deleteNotification(String id) {
    return _mutate(
      (accessToken) => _activeDataSource.deleteNotification(
        accessToken: accessToken,
        id: id,
      ),
    );
  }

  @override
  Future<Result<void>> registerDeviceToken({
    required String token,
    String? deviceType,
  }) {
    return _mutate(
      (accessToken) => _activeDataSource.registerDeviceToken(
        accessToken: accessToken,
        token: token,
        deviceType: deviceType,
      ),
    );
  }

  Future<Result<void>> _mutate(
    Future<void> Function(String? accessToken) request,
  ) async {
    try {
      final auth = await _authContext();
      if (auth.failure != null) {
        return Result.failure(auth.failure!);
      }

      await request(auth.accessToken);
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
          message: 'Sign in to view notifications.',
        ),
      );
    }

    return _AuthContext(accessToken: accessToken);
  }
}

class _AuthContext {
  const _AuthContext({this.accessToken, this.failure});

  final String? accessToken;
  final AppFailure? failure;
}
