import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_about_section.dart';
import '../widgets/profile_action_bar.dart';
import '../widgets/profile_action_notice.dart';
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
      overrides: [profileTargetProvider.overrideWithValue(idOrUsername)],
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends ConsumerWidget {
  const _ProfileScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    return switch (state.status) {
      ProfileStatus.loading => const PromooLoadingIndicator(
        message: 'Loading profile',
      ),
      ProfileStatus.error => _ProfileErrorView(state: state),
      ProfileStatus.empty => const PromooEmptyState(
        title: 'Profile not found',
        message: 'This profile is unavailable or no longer exists.',
        icon: Icons.person_off_rounded,
      ),
      ProfileStatus.success || ProfileStatus.refreshing => _ProfileContentView(
        state: state,
        onRefresh: () => ref.read(profileControllerProvider.notifier).refresh(),
      ),
    };
  }
}

class _ProfileErrorView extends ConsumerWidget {
  const _ProfileErrorView({required this.state});

  final ProfileState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  state.failure?.message ?? 'Could not refresh profile.',
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
      title: 'Could not load profile',
      message: state.failure?.message ?? 'Something went wrong. Try again.',
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
      return const PromooEmptyState(
        title: 'Profile not found',
        message: 'This profile is unavailable or no longer exists.',
        icon: Icons.person_off_rounded,
      );
    }
    final target = ref.watch(profileTargetProvider);
    final isOwnerProfile = target == null || target.trim().isEmpty;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primaryYellow,
          backgroundColor: AppColors.elevatedSurface,
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
                    ProfileHeader(profile: profile),
                    const SizedBox(height: AppSpacing.md),
                    ProfileStatsRow(stats: profile.stats),
                    const SizedBox(height: AppSpacing.md),
                    ProfileActionBar(
                      isOwner: isOwnerProfile,
                      onFollowPressed: () => ref
                          .read(profileControllerProvider.notifier)
                          .requestFollow(),
                      onMessagePressed: () => ref
                          .read(profileControllerProvider.notifier)
                          .requestMessage(),
                      onEditPressed: () => ref
                          .read(profileControllerProvider.notifier)
                          .requestEdit(),
                    ),
                    if (state.actionStatus != ProfileActionStatus.idle) ...[
                      const SizedBox(height: AppSpacing.md),
                      ProfileActionNotice(
                        status: state.actionStatus,
                        onLoginPressed: () => context.push(AppRoutes.login),
                        onChatsPressed: () => context.push(AppRoutes.chats),
                        onDismiss: () => ref
                            .read(profileControllerProvider.notifier)
                            .clearActionMessage(),
                      ),
                    ],
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
