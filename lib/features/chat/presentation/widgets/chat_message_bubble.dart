import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/chat.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final background = isMine ? AppColors.primaryYellow : AppColors.cardSurface;
    final foreground = isMine ? AppColors.brandBlack : AppColors.textPrimary;

    return Align(
      alignment: isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isMine ? AppColors.darkYellow : AppColors.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content.isEmpty ? 'Message' : message.content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: foreground),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _messageMeta(message),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isMine
                        ? AppColors.brandBlack.withValues(alpha: 0.72)
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _messageMeta(ChatMessage message) {
  final hour = message.createdAt.hour.toString().padLeft(2, '0');
  final minute = message.createdAt.minute.toString().padLeft(2, '0');
  if (message.isMine && message.status != ChatMessageStatus.unknown) {
    return '$hour:$minute - ${message.status.label}';
  }
  return '$hour:$minute';
}
