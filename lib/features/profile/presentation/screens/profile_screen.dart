import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_detail_header.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_about_section.dart';
import '../widgets/profile_action_bar.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_media_section.dart';
import '../widgets/profile_packages_section.dart';
import '../widgets/profile_stats_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.idOrUsername});

  final String? idOrUsername;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        profileTargetProvider.overrideWithValue(idOrUsername),
        // Re-create the controller inside THIS scope so it reads the scoped
        // target above. A root-scoped provider would ignore a nested override
        // and always load the demo profile.
        profileControllerProvider.overrideWith(ProfileController.new),
      ],
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends ConsumerWidget {
  const _ProfileScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: switch (state.status) {
          ProfileStatus.loading => PromooLoadingIndicator(
            message: l10n.profileLoadingMessage,
          ),
          ProfileStatus.error => _ProfileErrorView(state: state),
          ProfileStatus.empty => PromooEmptyState(
            title: l10n.profileEmptyTitle,
            message: l10n.profileEmptyMessage,
            icon: Icons.person_off_rounded,
          ),
          ProfileStatus.success ||
          ProfileStatus.refreshing => _ProfileContentView(
            state: state,
            onRefresh: () =>
                ref.read(profileControllerProvider.notifier).refresh(),
          ),
        },
      ),
    );
  }
}

class _ProfileErrorView extends ConsumerWidget {
  const _ProfileErrorView({required this.state});

  final ProfileState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (state.hasContent) {
      return Stack(
        children: [
          _ProfileContentView(
            state: state,
            onRefresh: () =>
                ref.read(profileControllerProvider.notifier).refresh(),
          ),
          PositionedDirectional(
            top: AppSpacing.md,
            start: AppSpacing.md,
            end: AppSpacing.md,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.error),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  state.failure?.message ?? l10n.profileRefreshErrorFallback,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return PromooErrorState(
      title: l10n.profileErrorTitle,
      message: state.failure?.message ?? l10n.commonSomethingWentWrong,
      onRetry: () => ref.read(profileControllerProvider.notifier).retry(),
    );
  }
}

class _ProfileContentView extends ConsumerWidget {
  const _ProfileContentView({required this.state, required this.onRefresh});

  final ProfileState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = state.profile;
    if (profile == null) {
      final l10n = AppLocalizations.of(context);
      return PromooEmptyState(
        title: l10n.profileEmptyTitle,
        message: l10n.profileEmptyMessage,
        icon: Icons.person_off_rounded,
      );
    }
    final target = ref.watch(profileTargetProvider);
    final isOwnerProfile = target == null || target.trim().isEmpty;

    return Stack(
      children: [
        RefreshIndicator(
          color: context.colors.accent,
          backgroundColor: context.colors.elevatedSurface,
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.screenVertical,
                  AppSpacing.screenHorizontal,
                  AppSpacing.shellScrollBottom,
                ),
                sliver: SliverList.list(
                  children: [
                    if (Navigator.of(context).canPop()) ...[
                      PromooDetailHeader(
                        title: AppLocalizations.of(
                          context,
                        ).profileDetailScreenTitle,
                        onBack: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.home);
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    ProfileHeader(profile: profile),
                    const SizedBox(height: AppSpacing.md),
                    ProfileStatsRow(stats: profile.stats),
                    const SizedBox(height: AppSpacing.md),
                    ProfileActionBar(
                      isOwner: isOwnerProfile,
                      isFollowing: state.isFollowing,
                      onFollowPressed: () => ref
                          .read(profileControllerProvider.notifier)
                          .toggleFollow(),
                      onMessagePressed: () => context.push(
                        AppRoutes.chatWithParticipant(profile.id),
                      ),
                      onEditPressed: () => context.push(AppRoutes.profileEdit),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ProfilePackagesSection(packages: state.packages),
                    const SizedBox(height: AppSpacing.lg),
                    ProfileMediaSection(
                      mediaUrls: profile.mediaUrls,
                      profileName: profile.displayName,
                      avatarUrl: profile.avatarUrl,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ProfileAboutSection(profile: profile),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.isRefreshing)
          const PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
