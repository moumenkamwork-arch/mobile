import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_names.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_mode_controller.dart';
import 'promoo_chat_icon.dart';
import 'promoo_logo.dart';

/// Standard in-shell page header matching the original app: a full-width bar
/// pinned to the very top (no side margins, only a bottom border), showing the
/// Promoo logo on the left and plain chat/notification icons with yellow
/// badges on the right. Becomes a translucent glass bar while scrolling.
///
/// Theme-aware: brand-black glass on dark, paper glass on light; the logo
/// itself switches to a colorway suited to each ([PromooLogo] picks the
/// right asset — no background plate needed).
class PromooPageHeader extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final backgroundColor = colors.background.withValues(
      alpha: isScrolled ? 0.72 : 0.9,
    );

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isScrolled
                ? colors.accent.withValues(alpha: 0.28)
                : colors.border,
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
                tooltip: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: colors.textPrimary,
                  size: 24,
                ),
                onTap: () {
                  final notifier = ref.read(themeModeProvider.notifier);
                  if (isDark) {
                    notifier.setLight();
                  } else {
                    notifier.setDark();
                  }
                },
              ),
              const SizedBox(width: AppSpacing.xxs),
              _HeaderAction(
                tooltip: 'Chats',
                badgeLabel: '2',
                icon: PromooChatIcon(size: 26, color: colors.textPrimary),
                onTap: () => context.push(AppRoutes.chats),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _HeaderAction(
                tooltip: 'Notifications',
                badgeLabel: '6',
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: colors.textPrimary,
                  size: 27,
                ),
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
  final Widget icon;
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
                icon,
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
