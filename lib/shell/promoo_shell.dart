import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routing/back_interceptors.dart';
import '../routing/route_names.dart';
import '../shared/widgets/promoo_logo.dart';
import '../shared/widgets/promoo_scaffold.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PromooShellTab {
  const PromooShellTab({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}

class PromooShell extends ConsumerStatefulWidget {
  const PromooShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  final Widget child;
  final int selectedIndex;

  static const tabs = [
    PromooShellTab(
      label: 'Home',
      route: AppRoutes.home,
      icon: Icons.home_rounded,
    ),
    PromooShellTab(
      label: 'Influencer',
      route: AppRoutes.seats,
      icon: Icons.event_seat_rounded,
    ),
    PromooShellTab(
      label: 'Services',
      route: AppRoutes.services,
      icon: Icons.storefront_rounded,
    ),
    PromooShellTab(
      label: 'Cup',
      route: AppRoutes.cup,
      icon: Icons.emoji_events_rounded,
    ),
    PromooShellTab(
      label: 'Profile',
      route: AppRoutes.profile,
      icon: Icons.person_rounded,
    ),
  ];

  @override
  ConsumerState<PromooShell> createState() => _PromooShellState();
}

class _PromooShellState extends ConsumerState<PromooShell> {
  bool _isScrolled = false;
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Screens may expose internal back layers (e.g. Services results
        // over the category grid) — unwind those first.
        if (ref.read(backInterceptorsProvider).handle()) {
          return;
        }

        // Step-wise back at the tab level: any non-Home tab first returns
        // to Home, and only Home itself exits (with double-press confirm).
        if (widget.selectedIndex != 0) {
          context.go(AppRoutes.home);
          return;
        }

        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2);
        final isWarning =
            _lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > maxDuration;

        if (isWarning) {
          _lastBackPressTime = now;
          final messenger = ScaffoldMessenger.of(context);
          final bottomOffset = (MediaQuery.sizeOf(context).height / 2 - 25)
              .clamp(0.0, 480.0);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text(
                  'Press back again to exit',
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsetsDirectional.only(
                  bottom: bottomOffset,
                  start: 60,
                  end: 60,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          return;
        }

        Future.microtask(() => SystemNavigator.pop());
      },
      // Status bar sits on the black chrome band in both themes, so its
      // icons stay light. Each tab pads for the status bar via its header
      // (applyTopSafeArea) so the chrome reaches the top edge.
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PromooScaffold(
          padding: EdgeInsets.zero,
          safeAreaTop: false,
          safeAreaBottom: false,
          extendBody: true,
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final nextScrolled = notification.metrics.pixels > 10;
              if (nextScrolled != _isScrolled) {
                setState(() => _isScrolled = nextScrolled);
              }
              return false;
            },
            child: widget.child,
          ),
          bottomNavigationBar: _PromooBottomNavigation(
            selectedIndex: widget.selectedIndex,
            isScrolled: _isScrolled,
            onDestinationSelected: (index) {
              if (index == widget.selectedIndex) {
                return;
              }
              context.go(PromooShell.tabs[index].route);
            },
          ),
        ),
      ),
    );
  }
}

/// Bottom bar chrome. Brand-black in BOTH themes: the center P artwork is
/// yellow and needs a dark field, and the black band is part of the Promoo
/// identity (see AppColors.navBackground).
class _PromooBottomNavigation extends StatelessWidget {
  const _PromooBottomNavigation({
    required this.selectedIndex,
    required this.isScrolled,
    required this.onDestinationSelected,
  });

  /// Height of the visible bar row (labels + icons). The center P mark
  /// overflows above this height by [_pOverflow].
  static const double barHeight = 62;
  static const double _pOverflow = 26;
  static const double _pSize = 54;

  final int selectedIndex;
  final bool isScrolled;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isScrolled
        ? AppColors.dark.navBackground.withValues(alpha: 0.78)
        : AppColors.dark.navBackground;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return SizedBox(
      // Room for the overflowing P above the full-width bar.
      height: barHeight + bottomInset + _pOverflow,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Full-width glass bar anchored to the very bottom, top border only.
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isScrolled ? 16 : 8,
                  sigmaY: isScrolled ? 16 : 8,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: isScrolled
                            ? AppColors.brandYellow.withValues(alpha: 0.30)
                            : AppColors.dark.border,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      height: barHeight,
                      child: Row(
                        children: [
                          for (
                            var index = 0;
                            index < PromooShell.tabs.length;
                            index++
                          )
                            Expanded(
                              child: index == 2
                                  ? _CenterServicesLabel(
                                      tab: PromooShell.tabs[index],
                                      selected: index == selectedIndex,
                                      onTap: () => onDestinationSelected(index),
                                    )
                                  : _PromooNavItem(
                                      tab: PromooShell.tabs[index],
                                      selected: index == selectedIndex,
                                      onTap: () => onDestinationSelected(index),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // The Services P mark, half overflowing above the bar, centered.
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            child: Center(
              child: _CenterPMark(
                size: _pSize,
                selected: selectedIndex == 2,
                onTap: () => onDestinationSelected(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterServicesLabel extends StatelessWidget {
  const _CenterServicesLabel({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final PromooShellTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
          child: Text(
            tab.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected
                  ? AppColors.brandYellow
                  : AppColors.dark.textMuted,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterPMark extends StatelessWidget {
  const _CenterPMark({
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Services tab',
      child: Tooltip(
        message: 'Services',
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.brandBlack,
              shape: BoxShape.circle,
              boxShadow: AppColors.dark.shadowElevated,
              border: Border.all(
                color: AppColors.brandYellow,
                width: selected ? 2.4 : 1.6,
              ),
            ),
            padding: const EdgeInsetsDirectional.all(11),
            child: Image.asset(
              PromooLogo.compactAsset,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _PromooNavItem extends StatelessWidget {
  const _PromooNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final PromooShellTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandYellow : AppColors.dark.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: '${tab.label} tab',
      child: Tooltip(
        message: tab.label,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, color: color, size: 24),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
