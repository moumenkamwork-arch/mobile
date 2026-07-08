import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_names.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'promoo_logo.dart';

/// Standard in-shell page header matching the original app: a full-width bar
/// pinned to the very top (no side margins, only a bottom border), showing the
/// Promoo logo on the left and plain chat/notification icons with yellow
/// badges on the right. Becomes a translucent glass bar while scrolling.
///
/// The header is brand-black chrome in BOTH themes: the logo artwork is
/// yellow and needs a dark field, and the black band is part of the Promoo
/// identity (see AppColors.navBackground).
class PromooPageHeader extends StatelessWidget {
  const PromooPageHeader({
    super.key,
    this.isScrolled = false,
    this.applyTopSafeArea = false,
  });

  final bool isScrolled;

  /// When the header is used as a fixed overlay (Home), it pads for the status
  /// bar itself. When it sits inside an existing SafeArea, leave this false.
  final bool applyTopSafeArea;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.brandBlack.withValues(
      alpha: isScrolled ? 0.72 : 0.9,
    );

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isScrolled
                ? AppColors.brandYellow.withValues(alpha: 0.28)
                : AppColors.dark.border,
          ),
        ),
      ),
      child: SafeArea(
        top: applyTopSafeArea,
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const PromooLogo.full(
                width: 132,
                height: 40,
                semanticLabel: 'Promoo page logo',
              ),
              const Spacer(),
              _HeaderAction(
                tooltip: 'Chats',
                badgeLabel: '2',
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () => context.push(AppRoutes.chats),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _HeaderAction(
                tooltip: 'Notifications',
                badgeLabel: '6',
                icon: Icons.notifications_none_rounded,
                onTap: () => context.push(AppRoutes.notifications),
              ),
            ],
          ),
        ),
      ),
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 14 : 0,
          sigmaY: isScrolled ? 14 : 0,
        ),
        child: bar,
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.badgeLabel,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: AppSpacing.touchTarget,
            height: AppSpacing.touchTarget,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // White on the black chrome band in both themes.
                Icon(icon, color: AppColors.dark.textPrimary, size: 27),
                if (badgeLabel != null)
                  PositionedDirectional(
                    top: 5,
                    end: 6,
                    child: Container(
                      height: 16,
                      constraints: const BoxConstraints(minWidth: 16),
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.brandYellow,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeLabel!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.brandBlack,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
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
