import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/theme_mode_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/account_capabilities.dart';

/// Profile tab page recreating the original app's profile/settings screen:
/// welcome card, Following, management menu, language selector, logout, and
/// footer legal links.
class ProfileMenuScreen extends ConsumerWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authControllerProvider).session?.user;
    final caps = ref.watch(accountCapabilitiesProvider);

    // The header paints its own status-bar inset so the black chrome band
    // reaches the top edge in both themes (no paper seam in light mode).
    return Column(
      children: [
        const PromooPageHeader(applyTopSafeArea: true),
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screenHorizontal,
              AppSpacing.md,
              AppSpacing.screenHorizontal,
              AppSpacing.shellScrollBottom,
            ),
            children: [
              _WelcomeCard(
                displayName: user?.displayName ?? 'Guest',
                avatarUrl: user?.avatarUrl,
              ),
              const SizedBox(height: AppSpacing.md),
              PromooCard(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: AppSpacing.xs,
                ),
                child: Column(children: _menuRows(context, caps)),
              ),
              const SizedBox(height: AppSpacing.md),
              PromooCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _RadioOption(
                      label: 'English',
                      selected: true,
                      onTap: () {},
                    ),
                    _RadioOption(
                      label: 'Arabic',
                      selected: false,
                      onTap: () => _showNotice(
                        context,
                        'Arabic will be available with the localization phase.',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Theme Mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _RadioOption(
                      label: 'Black Mode',
                      selected: themeMode == ThemeMode.dark,
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).setDark(),
                    ),
                    _RadioOption(
                      label: 'Light Mode',
                      selected: themeMode == ThemeMode.light,
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).setLight(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PromooCard(
                padding: EdgeInsets.zero,
                child: _MenuRow(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: () => _confirmLogout(context, ref),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FooterLink(
                    label: 'About',
                    onTap: () => context.push(AppRoutes.profileInfo('about')),
                  ),
                  const _FooterDot(),
                  _FooterLink(
                    label: 'TermsAndCondition',
                    onTap: () => context.push(AppRoutes.profileInfo('terms')),
                  ),
                  const _FooterDot(),
                  _FooterLink(
                    label: 'PrivacyPolicy',
                    onTap: () => context.push(AppRoutes.profileInfo('privacy')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colors.cardSurface,
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out of Promoo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(authControllerProvider.notifier).logout();
                context.go(AppRoutes.login);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Greeting card at the top of the settings screen: the signed-in user's
/// own avatar (not the brand logo) with a "Hi {name} / Welcome to Promoo"
/// greeting, matching the original app's welcome card layout.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.displayName, required this.avatarUrl});

  final String displayName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PromooCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.elevatedSurface,
              shape: BoxShape.circle,
              border: Border.all(color: colors.accent, width: 1.5),
            ),
            child: ClipOval(
              child: PromooImage(
                imageUrl: avatarUrl,
                semanticLabel: displayName,
                fallbackIcon: Icons.person_rounded,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $displayName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  'Welcome to Promoo',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Builds the settings menu rows, inserting dividers between them. The three
/// creation rows (Offer/Ad/Service) are gated by [AccountCapabilities] so the
/// user only ever sees the creation actions their `account_type` is allowed —
/// mirroring the backend's `requireAccountType` guards (see roles_logic.md):
/// Offer = company/service_provider · Ad = company/influencer ·
/// Service = company/service_provider. A guest or regular `user` sees none.
List<Widget> _menuRows(BuildContext context, AccountCapabilities caps) {
  final rows = <Widget>[
    _MenuRow(
      icon: Icons.star_rounded,
      label: 'Following',
      onTap: () => context.push(AppRoutes.profileFollowing),
    ),
    _MenuRow(
      icon: Icons.group_outlined,
      label: 'Profile Management',
      onTap: () => context.push(AppRoutes.profileEdit),
    ),
    if (caps.canAddOffer)
      _MenuRow(
        icon: Icons.local_offer_outlined,
        label: 'Add New Offer',
        onTap: () => context.push(AppRoutes.profileAddOffer),
      ),
    if (caps.canAddAd)
      _MenuRow(
        icon: Icons.campaign_outlined,
        label: 'Add New Ad',
        onTap: () => context.push(AppRoutes.profileAddAd),
      ),
    if (caps.canAddService)
      _MenuRow(
        icon: Icons.design_services_outlined,
        label: 'Add New Service',
        onTap: () => context.push(AppRoutes.profileAddService),
      ),
    _MenuRow(
      icon: Icons.bookmark_rounded,
      label: 'Saved',
      onTap: () => context.push(AppRoutes.profileSaved),
    ),
    _MenuRow(
      icon: Icons.inventory_2_outlined,
      label: 'MyPackages',
      onTap: () => context.push(AppRoutes.profilePackages),
    ),
    _MenuRow(
      icon: Icons.support_agent_rounded,
      label: 'Support',
      onTap: () => context.push(AppRoutes.profileSupport),
    ),
  ];

  final children = <Widget>[];
  for (var i = 0; i < rows.length; i++) {
    children.add(rows[i]);
    if (i != rows.length - 1) {
      children.add(const _MenuDivider());
    }
  }
  return children;
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
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
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      leading: Icon(icon, color: context.colors.accent, size: 26),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.colors.textMuted,
      ),
      onTap: onTap,
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
      child: Divider(height: 1),
    );
  }
}

class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: context.colors.accent,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.xxs,
          vertical: AppSpacing.xs,
        ),
        child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  const _FooterDot();

  @override
  Widget build(BuildContext context) {
    return Text('•', style: Theme.of(context).textTheme.bodyMedium);
  }
}
