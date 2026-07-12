import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/app_notification.dart';
import 'notification_type_label.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDelete,
  });

  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PromooCard(
      onTap: onTap,
      borderColor: notification.isUnread ? colors.accent : colors.border,
      color: notification.isUnread
          ? colors.elevatedSurface
          : colors.cardSurface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeIcon(type: notification.type, unread: notification.isUnread),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (notification.isUnread) const _UnreadDot(),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  notificationTypeLabel(context, notification.type),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              tooltip: AppLocalizations.of(context).notificationDeleteTooltip,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type, required this.unread});

  final NotificationType type;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Unread gets the highlighter chip: yellow fill + black ink.
    return CircleAvatar(
      radius: 22,
      backgroundColor: unread ? colors.primaryYellow : colors.elevatedSurface,
      foregroundColor: unread ? AppColors.brandBlack : colors.accent,
      child: Icon(_iconFor(type), size: 20),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: context.colors.accent,
        shape: BoxShape.circle,
      ),
    );
  }
}

IconData _iconFor(NotificationType type) {
  return switch (type) {
    NotificationType.follow => Icons.person_add_alt_1_rounded,
    NotificationType.message => Icons.chat_bubble_outline_rounded,
    NotificationType.offer => Icons.local_offer_outlined,
    NotificationType.system => Icons.info_outline_rounded,
    NotificationType.payment => Icons.payments_outlined,
    NotificationType.unknown => Icons.notifications_none_rounded,
  };
}
