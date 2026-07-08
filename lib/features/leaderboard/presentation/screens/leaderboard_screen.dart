import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_ranked_list.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardControllerProvider);

    return switch (state.status) {
      LeaderboardStatus.loading => const PromooLoadingIndicator(
        message: 'Loading leaderboard',
      ),
      LeaderboardStatus.error => _LeaderboardErrorView(state: state),
      LeaderboardStatus.empty ||
      LeaderboardStatus.success ||
      LeaderboardStatus.refreshing => _LeaderboardContentView(
        state: state,
        onRefresh: () =>
            ref.read(leaderboardControllerProvider.notifier).refresh(),
      ),
    };
  }
}

class _LeaderboardErrorView extends ConsumerWidget {
  const _LeaderboardErrorView({required this.state});

  final LeaderboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.hasContent) {
      return Stack(
        children: [
          _LeaderboardContentView(
            state: state,
            onRefresh: () =>
                ref.read(leaderboardControllerProvider.notifier).refresh(),
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
                  state.failure?.message ?? 'Could not refresh leaderboard.',
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
      title: 'Could not load leaderboard',
      message: state.failure?.message ?? 'Something went wrong. Try again.',
      onRetry: () => ref.read(leaderboardControllerProvider.notifier).retry(),
    );
  }
}

class _LeaderboardContentView extends StatelessWidget {
  const _LeaderboardContentView({required this.state, required this.onRefresh});

  final LeaderboardState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    // The header paints its own status-bar inset so the black chrome band
    // reaches the top edge in both themes (no paper seam in light mode).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooPageHeader(applyTopSafeArea: true),
        Expanded(child: _buildBody(context)),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  AppSpacing.md,
                  AppSpacing.screenHorizontal,
                  AppSpacing.shellScrollBottom,
                ),
                sliver: SliverList.list(
                  children: [
                    Text(
                      'Cup',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'The Promoo leaderboard ranked by follower reach.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.profiles.isEmpty)
                      const PromooEmptyState(
                        title: 'No leaderboard yet',
                        message:
                            'Ranked profiles will appear here when they are available.',
                        icon: Icons.emoji_events_rounded,
                      )
                    else ...[
                      LeaderboardPodium(
                        profiles: state.profiles.take(3).toList(),
                        onProfileSelected: (profile) =>
                            context.push(AppRoutes.profileById(profile.id)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LeaderboardRankedList(
                        profiles: state.profiles,
                        onProfileSelected: (profile) =>
                            context.push(AppRoutes.profileById(profile.id)),
                      ),
                    ],
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
