import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_list_header.dart';
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
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: context.colors.accent,
              backgroundColor: context.colors.elevatedSurface,
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
                          onSelected: (notification) =>
                              _openNotification(context, ref, notification),
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

/// Instagram-style: tapping a notification marks it read and jumps to whatever
/// it's about — a message opens the conversation, a follow opens the follower's
/// profile. Notifications with no destination (system/payment) just mark read.
void _openNotification(
  BuildContext context,
  WidgetRef ref,
  AppNotification notification,
) {
  ref.read(notificationsControllerProvider.notifier).markRead(notification);

  final roomId = notification.roomId;
  if (roomId != null && roomId.isNotEmpty) {
    context.push(AppRoutes.chatRoom(roomId));
    return;
  }

  if (notification.type == NotificationType.follow) {
    final profileId = notification.profileId;
    if (profileId != null && profileId.isNotEmpty) {
      context.push(AppRoutes.profileById(profileId));
    }
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
    final l10n = AppLocalizations.of(context);
    return PromooListHeader(
      title: l10n.headerNotifications,
      subtitle: l10n.notificationsUnreadSubtitle(unreadCount),
      onBack: onBack,
      trailing: TextButton(
        onPressed: onMarkAllRead,
        child: Text(l10n.notificationsMarkAllRead),
      ),
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
    final l10n = AppLocalizations.of(context);
    return switch (state.status) {
      NotificationsStatus.loading => SizedBox(
        height: 420,
        child: PromooLoadingIndicator(
          message: l10n.notificationsLoadingMessage,
        ),
      ),
      NotificationsStatus.empty => SizedBox(
        height: 420,
        child: PromooEmptyState(
          title: l10n.notificationsEmptyTitle,
          message: l10n.notificationsEmptyMessage,
          icon: Icons.notifications_none_rounded,
        ),
      ),
      NotificationsStatus.error =>
        state.isAuthRequired
            ? SizedBox(
                height: 420,
                child: PromooEmptyState(
                  title: l10n.commonLoginRequiredTitle,
                  message:
                      state.failure?.message ??
                      l10n.notificationsAuthRequiredMessage,
                  icon: Icons.lock_outline_rounded,
                  actionLabel: l10n.commonGoToLogin,
                  onActionPressed: onLogin,
                ),
              )
            : SizedBox(
                height: 420,
                child: PromooErrorState(
                  title: l10n.notificationsErrorTitle,
                  message:
                      state.failure?.message ??
                      l10n.commonSomethingWentWrongShort,
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
        color: context.colors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.error),
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
