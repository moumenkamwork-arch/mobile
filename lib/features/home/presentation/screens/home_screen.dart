import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/home_highlight_card.dart';
import '../widgets/home_preview_sections.dart';
import '../widgets/home_story_strip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return switch (state.status) {
      HomeStatus.loading => const PromooLoadingIndicator(
        message: 'Loading Promoo home',
      ),
      HomeStatus.empty => PromooEmptyState(
        title: 'Nothing to show yet',
        message: 'Promoo home content will appear here when it is available.',
        actionLabel: 'Retry',
        onActionPressed: () {
          ref.read(homeControllerProvider.notifier).retry();
        },
      ),
      HomeStatus.error => _HomeErrorView(state: state),
      HomeStatus.success || HomeStatus.refreshing => _HomeContentView(
        content: state.content ?? const HomeContent(),
        isRefreshing: state.isRefreshing,
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
      ),
    };
  }
}

class _HomeErrorView extends ConsumerWidget {
  const _HomeErrorView({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staleContent = state.content;
    final failure = state.failure;

    if (staleContent != null && !staleContent.isEmpty) {
      return Stack(
        children: [
          _HomeContentView(
            content: staleContent,
            onRefresh: () =>
                ref.read(homeControllerProvider.notifier).refresh(),
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
                  failure?.message ?? 'Could not refresh home content.',
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
      title: 'Could not load home',
      message: failure?.message ?? 'Something went wrong. Try again.',
      onRetry: () => ref.read(homeControllerProvider.notifier).retry(),
    );
  }
}

class _HomeContentView extends StatelessWidget {
  const _HomeContentView({
    required this.content,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  final HomeContent content;
  final RefreshCallback onRefresh;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final topOffers = content.offers.take(3).toList(growable: false);
    final forYouOffers = content.offers.skip(3).toList(growable: false);

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
                    const HomeHeader(),
                    if (content.stories.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeStoryStrip(stories: content.stories),
                    ],
                    if (topOffers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeOffersPreviewSection(
                        title: 'Top Offers',
                        subtitle: 'Featured offers from Promoo partners',
                        offers: topOffers,
                        layout: HomeOfferPreviewLayout.hero,
                      ),
                    ],
                    if (forYouOffers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeOffersPreviewSection(offers: forYouOffers),
                    ],
                    if (content.highlight != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const PromooSectionHeader(
                        title: 'Promoo of the Day',
                        subtitle: "Today's featured Promoo pick",
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HomeHighlightCard(
                        highlight: content.highlight!,
                        onTap: () {
                          context.go(
                            AppRoutes.homeItemDetail(
                              content.highlight!.detailType.routeValue,
                              content.highlight!.id,
                            ),
                          );
                        },
                      ),
                    ],
                    if (content.services.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeServicesPreviewSection(services: content.services),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isRefreshing)
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
