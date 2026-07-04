import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadows.dart';
import '../../../../theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.isScrolled = false});

  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    final backgroundAlpha = isScrolled ? 0.82 : 0.66;
    final borderAlpha = isScrolled ? 0.30 : 0.16;
    final blur = isScrolled ? 14.0 : 8.0;

    return ClipRRect(
      borderRadius: AppRadius.card,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: backgroundAlpha),
            borderRadius: AppRadius.card,
            border: Border.all(
              color: AppColors.primaryYellow.withValues(alpha: borderAlpha),
            ),
            boxShadow: isScrolled ? AppShadows.card : null,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final logoWidth = (constraints.maxWidth - 124)
                    .clamp(142.0, 170.0)
                    .toDouble();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: logoWidth,
                      child: PromooLogo.fullCropped(
                        width: logoWidth,
                        height: 64,
                        artworkScale: 2.75,
                        semanticLabel: 'Promoo header logo',
                      ),
                    ),
                    const Spacer(),
                    _HeaderAction(
                      tooltip: 'Chats',
                      badgeLabel: '2',
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => context.go(AppRoutes.chats),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _HeaderAction(
                      tooltip: 'Notifications',
                      badgeLabel: '6',
                      icon: Icons.notifications_none_rounded,
                      onTap: () => context.go(AppRoutes.notifications),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.badgeLabel,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final String badgeLabel;
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
              color: AppColors.background.withValues(alpha: 0.18),
              borderRadius: AppRadius.card,
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.24),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 24),
                PositionedDirectional(
                  top: 2,
                  end: 2,
                  child: Container(
                    height: 18,
                    constraints: const BoxConstraints(minWidth: 18),
                    alignment: Alignment.center,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      borderRadius: AppRadius.pill,
                      border: Border.all(color: AppColors.brandBlack),
                    ),
                    child: Text(
                      badgeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.brandBlack,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
