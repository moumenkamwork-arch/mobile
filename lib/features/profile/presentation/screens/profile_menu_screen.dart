import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../i18n/locale_controller.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_avatar_circle.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/theme_mode_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../controllers/account_capabilities.dart';
import '../controllers/profile_controller.dart';

/// Profile tab page recreating the original app's profile/settings screen:
/// welcome card, Following, management menu, language selector, logout, and
/// footer legal links.
class ProfileMenuScreen extends ConsumerWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final user = ref.watch(authControllerProvider).session?.user;
    final caps = ref.watch(accountCapabilitiesProvider);
    // The login response is Supabase's raw auth user — it carries no avatar
    // (that lives in `profiles`), so the owner's photo comes from the loaded
    // profile (`GET /profiles/me`), the same source Edit Profile uses. Falls
    // back to the session's avatar (usually null) for guests / before load.
    final ownerAvatarUrl = ref.watch(
      profileControllerProvider.select((state) => state.profile?.avatarUrl),
    );

    // The header is a pinned sliver so content scrolls under it and it frosts
    // on scroll, matching Home. It paints its own status-bar inset so the
    // chrome band reaches the top edge in both themes.
    final topInset = MediaQuery.paddingOf(context).top;
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: PromooPinnedHeaderDelegate(topInset: topInset),
        ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screenHorizontal,
            AppSpacing.md,
            AppSpacing.screenHorizontal,
            AppSpacing.shellScrollBottom,
          ),
          sliver: SliverList.list(
            children: [
              _WelcomeCard(
                displayName: user?.displayName ?? l10n.settingsGuest,
                avatarUrl: ownerAvatarUrl ?? user?.avatarUrl,
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
                      l10n.settingsLanguage,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _RadioOption(
                      label: l10n.settingsEnglish,
                      selected: locale.languageCode == 'en',
                      onTap: () =>
                          ref.read(localeProvider.notifier).setEnglish(),
                    ),
                    _RadioOption(
                      label: l10n.settingsArabic,
                      selected: locale.languageCode == 'ar',
                      onTap: () =>
                          ref.read(localeProvider.notifier).setArabic(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.settingsThemeMode,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _RadioOption(
                      label: l10n.settingsBlackMode,
                      selected: themeMode == ThemeMode.dark,
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).setDark(),
                    ),
                    _RadioOption(
                      label: l10n.settingsLightMode,
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
                  label: l10n.settingsLogout,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              PromooCard(
                padding: EdgeInsets.zero,
                child: _MenuRow(
                  icon: Icons.delete_forever_rounded,
                  label: l10n.settingsDeleteAccount,
                  labelColor: Colors.redAccent,
                  onTap: () => _confirmDeleteAccount(context, ref),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FooterLink(
                    label: l10n.footerAbout,
                    onTap: () => context.push(AppRoutes.profileInfo('about')),
                  ),
                  const _FooterDot(),
                  _FooterLink(
                    label: l10n.footerTerms,
                    onTap: () => context.push(AppRoutes.profileInfo('terms')),
                  ),
                  const _FooterDot(),
                  _FooterLink(
                    label: l10n.footerPrivacy,
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
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colors.cardSurface,
          title: Text(l10n.logoutDialogTitle),
          content: Text(l10n.logoutDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.actionCancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
              child: Text(l10n.settingsLogout),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colors.cardSurface,
          title: Text(l10n.deleteAccountConfirmTitle),
          content: Text(l10n.deleteAccountConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.actionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.deleteAccountConfirmButton,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await ref.read(profileRepositoryProvider).deleteAccount();
    if (!context.mounted) {
      return;
    }

    result.when(
      success: (_) async {
        await ref.read(authControllerProvider.notifier).logout();
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
      },
      failure: (_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
      },
    );
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
          PromooAvatarCircle(
            imageUrl: avatarUrl,
            semanticLabel: displayName,
            size: 48,
            borderColor: colors.accent,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).settingsGreeting(displayName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  AppLocalizations.of(context).settingsWelcomeSubtitle,
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
  final l10n = AppLocalizations.of(context);
  final rows = <Widget>[
    _MenuRow(
      icon: Icons.group_outlined,
      label: l10n.menuProfileManagement,
      onTap: () => context.push(AppRoutes.profileEdit),
    ),
    if (caps.canAddOffer)
      _MenuRow(
        icon: Icons.local_offer_outlined,
        label: l10n.menuAddOffer,
        onTap: () => context.push(AppRoutes.profileAddOffer),
      ),
    if (caps.canAddService)
      _MenuRow(
        icon: Icons.design_services_outlined,
        label: l10n.menuAddService,
        onTap: () => context.push(AppRoutes.profileAddService),
      ),
    if (caps.canCreateAnything)
      _MenuRow(
        icon: Icons.dashboard_customize_outlined,
        label: l10n.menuMyListings,
        onTap: () => context.push(AppRoutes.profileMyListings),
      ),
    _MenuRow(
      icon: Icons.bookmark_rounded,
      label: l10n.menuSaved,
      onTap: () => context.push(AppRoutes.profileSaved),
    ),

    // Following sits just above Support per owner request.
    _MenuRow(
      icon: Icons.star_rounded,
      label: l10n.menuFollowing,
      onTap: () => context.push(AppRoutes.profileFollowing),
    ),
    _MenuRow(
      icon: Icons.groups_rounded,
      label: l10n.menuFollowers,
      onTap: () => context.push(AppRoutes.profileFollowers),
    ),
    _MenuRow(
      icon: Icons.block_rounded,
      label: l10n.menuBlockedUsers,
      onTap: () => context.push(AppRoutes.profileBlockedUsers),
    ),
    _MenuRow(
      icon: Icons.support_agent_rounded,
      label: l10n.menuSupport,
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
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      leading: Icon(icon, color: labelColor ?? context.colors.accent, size: 26),
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: labelColor),
      ),
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
