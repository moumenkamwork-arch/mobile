import 'package:flutter/material.dart';

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
    return PromooCard(
      onTap: onTap,
      borderColor: room.hasUnread ? AppColors.primaryYellow : AppColors.border,
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
                  room.lastMessage?.content ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: room.hasUnread
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.elevatedSurface,
      foregroundColor: AppColors.primaryYellow,
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
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryYellow,
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
