import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
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
      LeaderboardStatus.loading => PromooLoadingIndicator(
        message: AppLocalizations.of(context).leaderboardLoadingMessage,
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
    final l10n = AppLocalizations.of(context);
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
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  state.failure?.message ??
                      l10n.leaderboardRefreshErrorFallback,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.colors.error),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return PromooErrorState(
      title: l10n.leaderboardErrorTitle,
      message: state.failure?.message ?? l10n.commonSomethingWentWrong,
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
    // The header is a pinned sliver inside the scroll view (see _buildBody) so
    // content scrolls under it and it frosts on scroll, matching Home.
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        RefreshIndicator(
          color: context.colors.accent,
          backgroundColor: context.colors.elevatedSurface,
          onRefresh: onRefresh,
          child: CustomScrollView(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_rounded,
                          color: context.colors.accent,
                          size: 32,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          l10n.leaderboardScreenTitle,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.leaderboardScreenSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (state.profiles.isEmpty)
                      PromooEmptyState(
                        title: l10n.leaderboardEmptyTitle,
                        message: l10n.leaderboardEmptyMessage,
                        icon: Icons.emoji_events_rounded,
                      )
                    else ...[
                      LeaderboardPodium(
                        profiles: state.profiles.take(3).toList(),
                        onProfileSelected: (profile) =>
                            context.push(AppRoutes.profileById(profile.id)),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
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
          PositionedDirectional(
            top: topInset + PromooPinnedHeaderDelegate.barHeight,
            start: 0,
            end: 0,
            child: const LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
