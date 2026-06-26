import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/profile_controller.dart';

class ProfileActionNotice extends StatelessWidget {
  const ProfileActionNotice({
    super.key,
    required this.status,
    required this.onDismiss,
    this.onLoginPressed,
    this.onChatsPressed,
  });

  final ProfileActionStatus status;
  final VoidCallback onDismiss;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onChatsPressed;

  @override
  Widget build(BuildContext context) {
    if (status == ProfileActionStatus.idle) {
      return const SizedBox.shrink();
    }

    final content = _contentFor(status);

    return PromooCard(
      borderColor: content.color,
      color: AppColors.elevatedSurface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(content.icon, color: content.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  content.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (content.showLoginAction && onLoginPressed != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PromooButton.secondary(
                    label: 'Go to login',
                    icon: Icons.login_rounded,
                    onPressed: onLoginPressed,
                  ),
                ],
                if (content.showChatsAction && onChatsPressed != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PromooButton.secondary(
                    label: 'Open chats',
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: onChatsPressed,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: 'Dismiss',
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

_NoticeContent _contentFor(ProfileActionStatus status) {
  return switch (status) {
    ProfileActionStatus.followAuthRequired => const _NoticeContent(
      title: 'Login required',
      message: 'Sign in to follow profiles when this action opens.',
      icon: Icons.lock_outline_rounded,
      color: AppColors.primaryYellow,
      showLoginAction: true,
    ),
    ProfileActionStatus.messageComingSoon => const _NoticeContent(
      title: 'Chats are ready',
      message: 'Open your Promoo inbox. Direct profile chats are coming soon.',
      icon: Icons.chat_bubble_outline_rounded,
      color: AppColors.warning,
      showChatsAction: true,
    ),
    ProfileActionStatus.editAuthRequired => const _NoticeContent(
      title: 'Coming soon',
      message: 'Profile editing will open from Profile tools soon.',
      icon: Icons.edit_rounded,
      color: AppColors.primaryYellow,
    ),
    ProfileActionStatus.idle => const _NoticeContent(
      title: '',
      message: '',
      icon: Icons.info_outline_rounded,
      color: AppColors.border,
    ),
  };
}

class _NoticeContent {
  const _NoticeContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.showLoginAction = false,
    this.showChatsAction = false,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool showLoginAction;
  final bool showChatsAction;
}
