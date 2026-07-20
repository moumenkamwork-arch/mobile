import 'package:promoo_app/l10n/app_localizations.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../routing/route_names.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_mode_controller.dart';
import '../state/shell_scroll_provider.dart';
import 'promoo_logo.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.isScrolled,
    this.applyTopSafeArea = false,
  });

  /// Whether to show the translucent "scrolled" glass state. When null (the
  /// in-shell tab pages), the header follows the shared [shellScrolledProvider]
  /// so it reacts to scroll in step with the bottom nav. Home passes an explicit
  /// value from its pinned sliver header.
  final bool? isScrolled;

  /// When the header is used as a fixed overlay (Home), it pads for the status
  /// bar itself. When it sits inside an existing SafeArea, leave this false.
  final bool applyTopSafeArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final bool scrolled = isScrolled ?? ref.watch(shellScrolledProvider);
    // Live unread counts drive the header badges (hidden at zero) instead of
    // hard-coded numbers.
    final chatUnread = ref.watch(
      chatControllerProvider.select((state) => state.totalUnread),
    );
    final notificationsUnread = ref.watch(
      notificationsControllerProvider.select((state) => state.unreadCount),
    );
    final backgroundColor = colors.background.withValues(alpha: scrolled ? 0.72 : 0.9,
    );

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: scrolled
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
                    ? l10n.headerSwitchToLightMode
                    : l10n.headerSwitchToDarkMode,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: colors.textSecondary,
                  size: 22,
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
                tooltip: l10n.headerChats,
                badgeLabel: _badgeLabel(chatUnread),
                icon: SvgPicture.asset(
                  'assets/brand/icons/chat.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    colors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () => context.push(AppRoutes.chats),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _HeaderAction(
                tooltip: l10n.headerNotifications,
                badgeLabel: _badgeLabel(notificationsUnread),
                icon: SvgPicture.asset(
                  'assets/brand/icons/notification.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    colors.textSecondary,
                    BlendMode.srcIn,
                  ),
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
          sigmaX: scrolled ? 14 : 0,
          sigmaY: scrolled ? 14 : 0,
        ),
        child: bar,
      ),
    );
  }
}

/// Formats an unread count for a header badge: `null` (no badge) when zero,
/// the number up to 9, then `9+`.
String? _badgeLabel(int count) {
  if (count <= 0) {
    return null;
  }
  return count > 9 ? '9+' : '$count';
}

/// Pinned sliver wrapper for [PromooPageHeader] so in-shell tab pages can let
/// their content scroll *under* the header — producing the same frosted-glass
/// reveal as Home instead of a flat bar with content stacked below it. It
/// detects overlap itself and drives the header's scrolled state, and reserves
/// the status-bar inset plus the bar height at the top of the scroll view.
class PromooPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const PromooPinnedHeaderDelegate({required this.topInset});

  final double topInset;

  /// Height of the header bar content below the status bar (logo + padding).
  static const double barHeight = 56;

  @override
  double get minExtent => topInset + barHeight;

  @override
  double get maxExtent => topInset + barHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return PromooPageHeader(
      isScrolled: overlapsContent || shrinkOffset > 0,
      applyTopSafeArea: true,
    );
  }

  @override
  bool shouldRebuild(covariant PromooPinnedHeaderDelegate oldDelegate) {
    return oldDelegate.topInset != topInset;
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
                      // Pill (not circle) so two-character labels like "9+"
                      // don't clip; a single digit still reads as a dot.
                      decoration: const BoxDecoration(
                        color: AppColors.brandYellow,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
