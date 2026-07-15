import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/domain/entities/auth_session.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../l10n/app_localizations.dart';
import '../routing/back_interceptors.dart';
import '../routing/route_names.dart';
import '../shared/state/shell_scroll_provider.dart';
import '../shared/widgets/promoo_logo.dart';
import '../shared/widgets/promoo_scaffold.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum PromooShellTabId { home, influencer, offers, promoo, services, profile }

/// Resolves the localized label for a tab. A separate function (not a field on
/// [PromooShellTab]) because the tab list is built at render time and can't
/// depend on `BuildContext`.
String promooShellTabLabel(BuildContext context, PromooShellTabId id) {
  final l10n = AppLocalizations.of(context);
  return switch (id) {
    PromooShellTabId.home => l10n.tabHome,
    PromooShellTabId.influencer => l10n.tabInfluencer,
    PromooShellTabId.offers => l10n.tabOffers,
    PromooShellTabId.promoo => l10n.tabPromoo,
    PromooShellTabId.services => l10n.tabServices,
    PromooShellTabId.profile => l10n.tabProfile,
  };
}

class PromooShellTab {
  const PromooShellTab({
    required this.id,
    required this.route,
    required this.icon,
  });

  final PromooShellTabId id;
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

  /// The five bottom-nav slots. Slot 1 is **role-dependent**: influencers see
  /// the Influencer/Seats tab (the Seats screen is influencer-only per client
  /// request), everyone else — companies, providers, regular users, guests —
  /// sees the Offers tab in that slot instead. All other slots and their
  /// indices are identical across roles (index 2 stays the center P mark).
  static List<PromooShellTab> tabsFor({required bool canViewSeats}) {
    final list = <PromooShellTab>[
      const PromooShellTab(
        id: PromooShellTabId.home,
        route: AppRoutes.home,
        icon: Icons.home_rounded,
      ),
      const PromooShellTab(
        id: PromooShellTabId.offers,
        route: AppRoutes.offers,
        icon: Icons.local_offer_rounded,
      ),
    ];

    if (canViewSeats) {
      list.add(
        const PromooShellTab(
          id: PromooShellTabId.influencer,
          route: AppRoutes.seats,
          icon: Icons.event_seat_rounded,
        ),
      );
    }

    list.addAll(const [
      // The elevated P mark. Leads to the Cup page and is labelled "Promoo".
      PromooShellTab(
        id: PromooShellTabId.promoo,
        route: AppRoutes.cup,
        icon: Icons.emoji_events_rounded,
      ),
      PromooShellTab(
        id: PromooShellTabId.services,
        route: AppRoutes.services,
        icon: Icons.storefront_rounded,
      ),
      PromooShellTab(
        id: PromooShellTabId.profile,
        route: AppRoutes.profile,
        icon: Icons.person_rounded,
      ),
    ]);

    return list;
  }

  @override
  ConsumerState<PromooShell> createState() => _PromooShellState();
}

class _PromooShellState extends ConsumerState<PromooShell> {
  DateTime? _lastBackPressTime;

  @override
  void didUpdateWidget(covariant PromooShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Each tab opens at the top, so clear any leftover "scrolled" glass state
    // carried over from the previous tab (the new body hasn't emitted a scroll
    // notification yet). Deferred to avoid mutating the provider mid-build.
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(shellScrolledProvider.notifier).set(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    final isScrolled = ref.watch(shellScrolledProvider);
    // Slot 1 swaps by role; recomputes automatically on login/logout.
    final session = ref.watch(authControllerProvider).session;
    final canViewSeats = session?.user.accountType == AuthAccountType.influencer ||
                         session?.user.accountType == AuthAccountType.company;
    final tabs = PromooShell.tabsFor(canViewSeats: canViewSeats);

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
                content: Text(
                  AppLocalizations.of(context).snackbarPressBackAgainToExit,
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
      // Status icons follow the header's actual tone: light icons on the
      // dark theme's black band, dark icons on the light theme's paper bar.
      // Each tab pads for the status bar via its header (applyTopSafeArea)
      // so the chrome reaches the top edge.
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: PromooScaffold(
          padding: EdgeInsets.zero,
          safeAreaTop: false,
          safeAreaBottom: false,
          extendBody: true,
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final nextScrolled = notification.metrics.pixels > 10;
              ref.read(shellScrolledProvider.notifier).set(nextScrolled);
              return false;
            },
            child: widget.child,
          ),
          bottomNavigationBar: _PromooBottomNavigation(
            tabs: tabs,
            selectedIndex: widget.selectedIndex,
            isScrolled: isScrolled,
            onDestinationSelected: (index) {
              if (index == widget.selectedIndex) {
                return;
              }
              context.go(tabs[index].route);
            },
          ),
        ),
      ),
    );
  }
}

/// Bottom bar chrome — theme-aware paper/black glass, matching the header.
/// The center P mark stays its own self-contained black-and-yellow "ink
/// stamp" in both themes (see [_CenterPMark]); it doesn't need the chrome
/// bar underneath it to be dark to stay legible.
class _PromooBottomNavigation extends StatelessWidget {
  const _PromooBottomNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.isScrolled,
    required this.onDestinationSelected,
  });

  /// Height of the visible bar row (labels + icons). The center P mark
  /// overflows above this height by [_pOverflow].
  static const double barHeight = 62;
  static const double _pOverflow = 26;
  static const double _pSize = 54;

  final List<PromooShellTab> tabs;
  final int selectedIndex;
  final bool isScrolled;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final backgroundColor = isScrolled
        ? colors.navBackground.withValues(alpha: 0.78)
        : colors.navBackground;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final promooIndex = tabs.indexWhere((t) => t.id == PromooShellTabId.promoo);

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
                            ? colors.accent.withValues(alpha: 0.30)
                            : colors.border,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      height: barHeight,
                      child: Row(
                        children: [
                          for (var index = 0; index < tabs.length; index++)
                            Expanded(
                              child: index == promooIndex
                                  ? _CenterServicesLabel(
                                      tab: tabs[index],
                                      selected: index == selectedIndex,
                                      onTap: () => onDestinationSelected(index),
                                    )
                                  : _PromooNavItem(
                                      tab: tabs[index],
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
          // The Services P mark, half overflowing above the bar.
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            child: Align(
              alignment: AlignmentDirectional(
                -1.0 + (2.0 * promooIndex + 1.0) / tabs.length,
                -1.0,
              ),
              child: _CenterPMark(
                size: _pSize,
                selected: selectedIndex == promooIndex,
                onTap: () => onDestinationSelected(promooIndex),
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
            promooShellTabLabel(context, tab.id),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected
                  ? context.colors.accent
                  : context.colors.textMuted,
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
    final l10n = AppLocalizations.of(context);
    final label = promooShellTabLabel(context, PromooShellTabId.promoo);
    return Semantics(
      button: true,
      selected: selected,
      label: l10n.tabSemanticLabel(label),
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.brandBlack,
              shape: BoxShape.circle,
              boxShadow: context.colors.shadowElevated,
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
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final color = selected ? colors.accent : colors.textMuted;
    final label = promooShellTabLabel(context, tab.id);

    return Semantics(
      button: true,
      selected: selected,
      label: l10n.tabSemanticLabel(label),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, color: color, size: 24),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                label,
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
