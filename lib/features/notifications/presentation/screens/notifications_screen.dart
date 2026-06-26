import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/app_notification.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primaryYellow,
              backgroundColor: AppColors.elevatedSurface,
              onRefresh: () =>
                  ref.read(notificationsControllerProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.lg,
                      AppSpacing.screenHorizontal,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverList.list(
                      children: [
                        _NotificationsHeader(
                          unreadCount: state.unreadCount,
                          onBack: () => _goBack(context),
                          onMarkAllRead: state.unreadCount == 0
                              ? null
                              : () => ref
                                    .read(
                                      notificationsControllerProvider.notifier,
                                    )
                                    .markAllRead(),
                        ),
                        if (state.actionFailure != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _ActionFailureBanner(
                            message: state.actionFailure!.message,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        _NotificationsBody(
                          state: state,
                          onRetry: () => ref
                              .read(notificationsControllerProvider.notifier)
                              .retry(),
                          onLogin: () => context.go(AppRoutes.login),
                          onSelected: (notification) {
                            ref
                                .read(notificationsControllerProvider.notifier)
                                .markRead(notification);
                            final roomId = notification.roomId;
                            if (roomId != null) {
                              context.go(AppRoutes.chatRoom(roomId));
                            }
                          },
                          onDelete: (notification) => ref
                              .read(notificationsControllerProvider.notifier)
                              .deleteNotification(notification),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state.isRefreshing)
              const PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({
    required this.unreadCount,
    required this.onBack,
    this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onBack;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                unreadCount == 0
                    ? 'No unread notifications.'
                    : '$unreadCount unread notifications',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onMarkAllRead,
          child: const Text('Mark all read'),
        ),
      ],
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody({
    required this.state,
    required this.onRetry,
    required this.onLogin,
    required this.onSelected,
    required this.onDelete,
  });

  final NotificationsState state;
  final VoidCallback onRetry;
  final VoidCallback onLogin;
  final ValueChanged<AppNotification> onSelected;
  final ValueChanged<AppNotification> onDelete;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      NotificationsStatus.loading => const SizedBox(
        height: 420,
        child: PromooLoadingIndicator(message: 'Loading notifications'),
      ),
      NotificationsStatus.empty => const SizedBox(
        height: 420,
        child: PromooEmptyState(
          title: 'No notifications',
          message: 'Promoo updates and messages will appear here.',
          icon: Icons.notifications_none_rounded,
        ),
      ),
      NotificationsStatus.error =>
        state.isAuthRequired
            ? SizedBox(
                height: 420,
                child: PromooEmptyState(
                  title: 'Login required',
                  message:
                      state.failure?.message ??
                      'Sign in to view notifications.',
                  icon: Icons.lock_outline_rounded,
                  actionLabel: 'Go to login',
                  onActionPressed: onLogin,
                ),
              )
            : SizedBox(
                height: 420,
                child: PromooErrorState(
                  title: 'Could not load notifications',
                  message: state.failure?.message ?? 'Something went wrong.',
                  onRetry: onRetry,
                ),
              ),
      NotificationsStatus.success || NotificationsStatus.refreshing => Column(
        children: [
          for (var i = 0; i < state.notifications.length; i++) ...[
            NotificationCard(
              notification: state.notifications[i],
              onTap: () => onSelected(state.notifications[i]),
              onDelete: () => onDelete(state.notifications[i]),
            ),
            if (i != state.notifications.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    };
  }
}

class _ActionFailureBanner extends StatelessWidget {
  const _ActionFailureBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}
