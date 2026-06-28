import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PromooLogo.compact(width: 36, height: 36),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Promoo', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                'Discover what is trending today',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeaderAction(
          tooltip: 'Chats',
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => context.go(AppRoutes.chats),
        ),
        const SizedBox(width: AppSpacing.xs),
        _HeaderAction(
          tooltip: 'Notifications',
          icon: Icons.notifications_none_rounded,
          onTap: () => context.go(AppRoutes.notifications),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Ink(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textMuted, size: 22),
          ),
        ),
      ),
    );
  }
}
