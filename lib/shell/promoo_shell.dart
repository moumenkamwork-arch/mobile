import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../shared/widgets/promoo_scaffold.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
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

class PromooShell extends StatelessWidget {
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
      label: 'Seats',
      route: AppRoutes.seats,
      icon: Icons.event_seat_rounded,
    ),
    PromooShellTab(
      label: 'Profile',
      route: AppRoutes.profile,
      icon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PromooScaffold(
      padding: EdgeInsets.zero,
      safeAreaBottom: false,
      body: child,
      bottomNavigationBar: _PromooBottomNavigation(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == selectedIndex) {
            return;
          }
          context.go(tabs[index].route);
        },
      ),
    );
  }
}

class _PromooBottomNavigation extends StatelessWidget {
  const _PromooBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: AppRadius.bottomNav,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.elevated,
        ),
        child: Row(
          children: [
            for (var index = 0; index < PromooShell.tabs.length; index++)
              Expanded(
                child: _PromooNavItem(
                  tab: PromooShell.tabs[index],
                  selected: index == selectedIndex,
                  onTap: () => onDestinationSelected(index),
                ),
              ),
          ],
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
    final color = selected ? AppColors.primaryYellow : AppColors.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: '${tab.label} tab',
      child: Tooltip(
        message: tab.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.lg == 16
                ? const BorderRadius.all(Radius.circular(AppRadius.lg))
                : AppRadius.card,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              constraints: const BoxConstraints(
                minHeight: AppSpacing.touchTarget,
              ),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.elevatedSurface
                    : Colors.transparent,
                borderRadius: AppRadius.card,
                border: Border.all(
                  color: selected ? AppColors.borderStrong : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.icon, color: color, size: 22),
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
        ),
      ),
    );
  }
}
