import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../shared/widgets/promoo_card.dart';
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
      label: 'Services',
      route: AppRoutes.services,
      icon: Icons.storefront_rounded,
    ),
    PromooShellTab(
      label: 'Promoo',
      route: AppRoutes.cup,
      icon: Icons.emoji_events_rounded,
    ),
    PromooShellTab(
      label: 'Influencer',
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
  ConsumerState<PromooShell> createState() => _PromooShellState();
}

class _PromooShellState extends ConsumerState<PromooShell> {
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return PromooScaffold(
      padding: EdgeInsets.zero,
      safeAreaBottom: false,
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
          if (index == 4) {
            _showProfileMenu(context);
            return;
          }
          if (index == widget.selectedIndex) {
            return;
          }
          context.go(PromooShell.tabs[index].route);
        },
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _ProfileMenuSheet(
          onViewProfile: () {
            Navigator.of(sheetContext).pop();
            context.go(AppRoutes.profile);
          },
          onPreviewAction: (label) {
            Navigator.of(sheetContext).pop();
            _showMenuNotice(context, label);
          },
        );
      },
    );
  }

  void _showMenuNotice(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(label.endsWith('.') ? label : '$label coming soon'),
        ),
      );
  }
}

class _PromooBottomNavigation extends StatelessWidget {
  const _PromooBottomNavigation({
    required this.selectedIndex,
    required this.isScrolled,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final bool isScrolled;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isScrolled
        ? AppColors.navBackground.withValues(alpha: 0.72)
        : AppColors.navBackground;

    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.bottomNav,
          boxShadow: isScrolled
              ? AppShadows.elevated
              : [
                  BoxShadow(
                    color: AppColors.primaryYellow.withValues(alpha: 0.08),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.bottomNav,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isScrolled ? 14 : 6,
              sigmaY: isScrolled ? 14 : 6,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: AppRadius.bottomNav,
                border: Border.all(
                  color: isScrolled
                      ? AppColors.primaryYellow.withValues(alpha: 0.28)
                      : AppColors.border,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
                child: Row(
                  children: [
                    for (
                      var index = 0;
                      index < PromooShell.tabs.length;
                      index++
                    )
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
                  if (tab.route == AppRoutes.cup)
                    Text(
                      'P',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  else
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

class _ProfileMenuSheet extends StatelessWidget {
  const _ProfileMenuSheet({
    required this.onViewProfile,
    required this.onPreviewAction,
  });

  final VoidCallback onViewProfile;
  final ValueChanged<String> onPreviewAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: AppSpacing.md,
          end: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: PromooCard(
          color: AppColors.elevatedSurface,
          borderColor: AppColors.primaryYellow.withValues(alpha: 0.42),
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsetsDirectional.only(
                    bottom: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.borderStrong,
                    borderRadius: AppRadius.pill,
                  ),
                ),
              ),
              Text(
                'Profile menu',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Manage your Promoo presence.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              _MenuAction(
                icon: Icons.person_rounded,
                label: 'View Profile',
                onTap: onViewProfile,
              ),
              _MenuAction(
                icon: Icons.edit_rounded,
                label: 'Edit Profile',
                onTap: () => onPreviewAction('Edit Profile'),
              ),
              _MenuAction(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved',
                onTap: () => onPreviewAction('Saved'),
              ),
              _MenuAction(
                icon: Icons.language_rounded,
                label: 'Language',
                onTap: () => onPreviewAction('Language'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Theme Mode', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  ChoiceChip(
                    label: const Text('Black Mode'),
                    selected: true,
                    onSelected: (_) => onPreviewAction(
                      'Theme options will be available in the next phase.',
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('Light Mode'),
                    selected: false,
                    onSelected: (_) => onPreviewAction(
                      'Theme options will be available in the next phase.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _MenuAction(
                icon: Icons.support_agent_rounded,
                label: 'Support',
                onTap: () => onPreviewAction('Support'),
              ),
              _MenuAction(
                icon: Icons.logout_rounded,
                label: 'Logout',
                onTap: () => onPreviewAction('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuAction extends StatelessWidget {
  const _MenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryYellow),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
