import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:promoo_app/features/notifications/domain/entities/app_notification.dart';
import 'package:promoo_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:promoo_app/features/notifications/presentation/controllers/notifications_controller.dart';

void main() {
  test('emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(
          _NotificationsRepository(
            notificationsResult: Result.success([_notification]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(notificationsControllerProvider).status,
      NotificationsStatus.loading,
    );
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationsControllerProvider);
    expect(state.status, NotificationsStatus.success);
    expect(state.unreadCount, 1);
  });

  test('marks all notifications read', () async {
    final container = ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(
          _NotificationsRepository(
            notificationsResult: Result.success([_notification]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(notificationsControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await container
        .read(notificationsControllerProvider.notifier)
        .markAllRead();

    final state = container.read(notificationsControllerProvider);
    expect(state.unreadCount, 0);
  });

  test('emits auth-required error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(
          const _NotificationsRepository(
            notificationsResult: Result.failure(
              AppFailure.unauthorized(message: 'Sign in'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(notificationsControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationsControllerProvider);
    expect(state.status, NotificationsStatus.error);
    expect(state.isAuthRequired, isTrue);
  });
}

final _notification = AppNotification(
  id: 'notification-1',
  title: 'New message',
  body: 'Noura Studio sent an update.',
  type: NotificationType.message,
  createdAt: DateTime(2026, 6, 26, 9, 22),
  data: const {'room_id': 'room-1'},
);

class _NotificationsRepository implements NotificationsRepository {
  const _NotificationsRepository({required this.notificationsResult});

  final Result<List<AppNotification>> notificationsResult;

  @override
  Future<Result<void>> deleteNotification(String id) async {
    return const Result.success(null);
  }

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    return notificationsResult;
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
