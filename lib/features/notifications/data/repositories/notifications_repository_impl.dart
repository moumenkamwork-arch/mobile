import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_data_source.dart';
import '../datasources/notifications_remote_data_source.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepositoryImpl(
    dataSource: ref.watch(notificationsRemoteDataSourceProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
  );
});

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({
    required this.dataSource,
    required this.sessionStore,
  });

  final NotificationsDataSource dataSource;
  final AuthSessionStore sessionStore;

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final accessToken = await _accessToken();
      final dto = await dataSource.fetchNotifications(
        accessToken: accessToken,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain());
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> markRead(String id) {
    return _mutate(
      (accessToken) => dataSource.markRead(accessToken: accessToken, id: id),
    );
  }

  @override
  Future<Result<void>> markAllRead() {
    return _mutate(
      (accessToken) => dataSource.markAllRead(accessToken: accessToken),
    );
  }

  @override
  Future<Result<void>> deleteNotification(String id) {
    return _mutate(
      (accessToken) =>
          dataSource.deleteNotification(accessToken: accessToken, id: id),
    );
  }

  @override
  Future<Result<void>> registerDeviceToken({
    required String token,
    String? deviceType,
  }) {
    return _mutate(
      (accessToken) => dataSource.registerDeviceToken(
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
      await request(await _accessToken());
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  Future<String?> _accessToken() async {
    final session = await sessionStore.read();
    return session?.tokens?.accessToken;
  }
}
