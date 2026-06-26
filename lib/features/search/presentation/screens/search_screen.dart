import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/search_result.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_filter_chips.dart';
import '../widgets/search_input.dart';
import '../widgets/search_results_list.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchControllerProvider);

    return _SearchContentView(
      state: state,
      onRefresh: () => ref.read(searchControllerProvider.notifier).refresh(),
      onQueryChanged: (query) =>
          ref.read(searchControllerProvider.notifier).updateQuery(query),
      onSubmitted: (query) =>
          ref.read(searchControllerProvider.notifier).submitSearch(query),
      onClear: () => ref.read(searchControllerProvider.notifier).clear(),
      onFilterSelected: (filter) =>
          ref.read(searchControllerProvider.notifier).selectFilter(filter),
      onRetry: () => ref.read(searchControllerProvider.notifier).retry(),
    );
  }
}

class _SearchContentView extends StatelessWidget {
  const _SearchContentView({
    required this.state,
    required this.onRefresh,
    required this.onQueryChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onFilterSelected,
    required this.onRetry,
  });

  final SearchState state;
  final RefreshCallback onRefresh;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final ValueChanged<SearchFilterType> onFilterSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primaryYellow,
          backgroundColor: AppColors.elevatedSurface,
          onRefresh:
              state.query.trim().length >= SearchController.minQueryLength
              ? onRefresh
              : () async {},
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
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Find profiles, services, offers, and promoted content.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchInput(
                      query: state.query,
                      onChanged: onQueryChanged,
                      onSubmitted: onSubmitted,
                      onClear: onClear,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SearchFilterChips(
                      selectedFilter: state.selectedFilter,
                      onSelected: onFilterSelected,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SearchBody(
                      state: state,
                      onRetry: onRetry,
                      onProfileSelected: (profile) {
                        context.go(AppRoutes.profileById(profile.id));
                      },
                    ),
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

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.state,
    required this.onRetry,
    required this.onProfileSelected,
  });

  final SearchState state;
  final VoidCallback onRetry;
  final ValueChanged<SearchProfileResult> onProfileSelected;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      SearchStatus.idle => PromooEmptyState(
        title: state.hasShortQuery ? 'Keep typing' : 'Search Promoo',
        message: state.hasShortQuery
            ? 'Enter at least 2 characters to search.'
            : 'Search by profile, service, offer, or campaign name.',
        icon: Icons.search_rounded,
      ),
      SearchStatus.loading => const SizedBox(
        height: 300,
        child: PromooLoadingIndicator(message: 'Searching Promoo'),
      ),
      SearchStatus.error =>
        state.hasContent
            ? Column(
                children: [
                  _InlineError(message: state.failure?.message),
                  const SizedBox(height: AppSpacing.md),
                  SearchResultsList(
                    results: state.results,
                    onProfileSelected: onProfileSelected,
                    onServiceSelected: (service) {
                      context.go(AppRoutes.serviceById(service.id));
                    },
                    onOfferSelected: (offer) {
                      context.go(AppRoutes.homeItemDetail('offer', offer.id));
                    },
                    onAdSelected: (ad) {
                      context.go(AppRoutes.homeItemDetail('ad', ad.id));
                    },
                  ),
                ],
              )
            : PromooErrorState(
                title: 'Could not search',
                message: state.failure?.message ?? 'Something went wrong.',
                onRetry: onRetry,
              ),
      SearchStatus.empty => PromooEmptyState(
        title: 'No results found',
        message: 'Try another search term or result type.',
        icon: Icons.search_off_rounded,
        actionLabel: 'Search again',
        onActionPressed: onRetry,
      ),
      SearchStatus.success || SearchStatus.refreshing => SearchResultsList(
        results: state.results,
        onProfileSelected: onProfileSelected,
        onServiceSelected: (service) {
          context.go(AppRoutes.serviceById(service.id));
        },
        onOfferSelected: (offer) {
          context.go(AppRoutes.homeItemDetail('offer', offer.id));
        },
        onAdSelected: (ad) {
          context.go(AppRoutes.homeItemDetail('ad', ad.id));
        },
      ),
    };
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: Text(
          message ?? 'Could not refresh search results.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
