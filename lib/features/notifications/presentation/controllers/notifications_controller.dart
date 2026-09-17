import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/realtime/notifications_realtime_service.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/entities/app_notification.dart';

final notificationsControllerProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
      NotificationsController.new,
    );

enum NotificationsStatus { loading, success, empty, error, refreshing }

class NotificationsState {
  const NotificationsState({
    required this.status,
    this.notifications = const [],
    this.failure,
    this.actionFailure,
  });

  const NotificationsState.loading()
    : this(status: NotificationsStatus.loading);

  const NotificationsState.success({
    required List<AppNotification> notifications,
    AppFailure? actionFailure,
  }) : this(
         status: NotificationsStatus.success,
         notifications: notifications,
         actionFailure: actionFailure,
       );

  const NotificationsState.empty() : this(status: NotificationsStatus.empty);

  const NotificationsState.error({
    required AppFailure failure,
    List<AppNotification> notifications = const [],
  }) : this(
         status: NotificationsStatus.error,
         failure: failure,
         notifications: notifications,
       );

  const NotificationsState.refreshing({
    required List<AppNotification> notifications,
  }) : this(
         status: NotificationsStatus.refreshing,
         notifications: notifications,
       );

  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final AppFailure? failure;
  final AppFailure? actionFailure;

  bool get isRefreshing => status == NotificationsStatus.refreshing;

  bool get hasContent => notifications.isNotEmpty;

  bool get isAuthRequired => failure?.type == AppFailureType.unauthorized;

  int get unreadCount {
    return notifications.where((notification) => notification.isUnread).length;
  }
}

class NotificationsController extends Notifier<NotificationsState> {
  var _disposed = false;
  StreamSubscription<AppNotification>? _realtimeSub;

  @override
  NotificationsState build() {
    ref.onDispose(() {
      _disposed = true;
      _realtimeSub?.cancel();
    });

    // The list is fetched once at first build — for most sessions that's while
    // still a guest (the header mounts before login), so without this the list
    // and the header's unread badge would stay empty forever after signing in.
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final wasAuthed = previous?.isAuthenticated ?? false;
      if (next.isAuthenticated != wasAuthed) {
        unawaited(load());
      }
    });

    // A new follower / incoming message writes a notification row; Realtime
    // pushes it here so it lands in the list and the badge live, no refresh.
    _realtimeSub = ref
        .read(notificationsRealtimeServiceProvider)
        .notifications
        .listen(_onRealtimeNotification);

    unawaited(Future<void>.microtask(load));
    return const NotificationsState.loading();
  }

  void _onRealtimeNotification(AppNotification notification) {
    if (_disposed) {
      return;
    }
    // Prepend (newest first), de-duplicating by id in case a refresh already
    // pulled it in.
    final merged = [
      notification,
      for (final item in state.notifications)
        if (item.id != notification.id) item,
    ];
    state = NotificationsState.success(notifications: merged);
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return _load(showLoading: true);
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.isRead) {
      return;
    }

    final result = await ref
        .read(notificationsRepositoryProvider)
        .markRead(notification.id);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (_) => _successWith([
        for (final item in state.notifications)
          if (item.id == notification.id)
            AppNotification(
              id: item.id,
              title: item.title,
              body: item.body,
              type: item.type,
              createdAt: item.createdAt,
              isRead: true,
              data: item.data,
            )
          else
            item,
      ]),
      failure: (failure) =>
          _successWith(state.notifications, actionFailure: failure),
    );
  }

  Future<void> markAllRead() async {
    final result = await ref
        .read(notificationsRepositoryProvider)
        .markAllRead();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (_) => _successWith([
        for (final item in state.notifications)
          AppNotification(
            id: item.id,
            title: item.title,
            body: item.body,
            type: item.type,
            createdAt: item.createdAt,
            isRead: true,
            data: item.data,
          ),
      ]),
      failure: (failure) =>
          _successWith(state.notifications, actionFailure: failure),
    );
  }

  Future<void> deleteNotification(AppNotification notification) async {
    final result = await ref
        .read(notificationsRepositoryProvider)
        .deleteNotification(notification.id);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (_) {
        final remaining = [
          for (final item in state.notifications)
            if (item.id != notification.id) item,
        ];
        if (remaining.isEmpty) {
          return const NotificationsState.empty();
        }
        return NotificationsState.success(notifications: remaining);
      },
      failure: (failure) =>
          _successWith(state.notifications, actionFailure: failure),
    );
  }

  Future<void> registerDemoToken() async {
    final result = await ref
        .read(notificationsRepositoryProvider)
        .registerDeviceToken(token: 'demo-token', deviceType: 'web');
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (_) => _successWith(state.notifications),
      failure: (failure) =>
          _successWith(state.notifications, actionFailure: failure),
    );
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final previousNotifications = state.notifications;
    if (refreshing) {
      state = NotificationsState.refreshing(
        notifications: previousNotifications,
      );
    } else if (showLoading) {
      state = const NotificationsState.loading();
    }

    final result = await ref
        .read(notificationsRepositoryProvider)
        .getNotifications();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (notifications) {
        if (notifications.isEmpty) {
          return const NotificationsState.empty();
        }
        return NotificationsState.success(notifications: notifications);
      },
      failure: (failure) => NotificationsState.error(
        failure: failure,
        notifications: refreshing ? previousNotifications : const [],
      ),
    );
  }

  NotificationsState _successWith(
    List<AppNotification> notifications, {
    AppFailure? actionFailure,
  }) {
    if (notifications.isEmpty) {
      return const NotificationsState.empty();
    }
    return NotificationsState.success(
      notifications: notifications,
      actionFailure: actionFailure,
    );
  }
}
