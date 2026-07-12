import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/chat.dart';

class ChatRoomCard extends StatelessWidget {
  const ChatRoomCard({super.key, required this.room, this.onTap});

  final ChatRoom room;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PromooCard(
      onTap: onTap,
      borderColor: room.hasUnread ? colors.primaryYellow : colors.border,
      elevated: room.hasUnread,
      child: Row(
        children: [
          _ParticipantAvatar(participant: room.participant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        room.participant.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (room.hasUnread) _UnreadBadge(count: room.unreadCount),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  room.lastMessage?.content ??
                      AppLocalizations.of(context).chatNoMessagesYet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: room.hasUnread
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.chevron_right_rounded, color: colors.textMuted),
        ],
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.participant});

  final ChatParticipant participant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CircleAvatar(
      radius: 24,
      backgroundColor: colors.elevatedSurface,
      foregroundColor: colors.primaryYellow,
      child: Text(
        participant.initials,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: colors.primaryYellow,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99' : '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.brandBlack,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
