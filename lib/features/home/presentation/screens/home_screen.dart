import 'package:promoo_app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeControllerProvider);

    return switch (state.status) {
      HomeStatus.loading => PromooLoadingIndicator(
        message: l10n.homeLoadingMessage,
      ),
      HomeStatus.empty => PromooEmptyState(
        title: l10n.homeEmptyTitle,
        message: l10n.homeEmptyMessage,
        actionLabel: l10n.actionRetry,
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
    final l10n = AppLocalizations.of(context);
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
                color: context.colors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.error),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  failure?.message ?? l10n.homeRefreshErrorFallback,
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
      title: l10n.homeErrorTitle,
      message: failure?.message ?? l10n.commonSomethingWentWrong,
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
    final l10n = AppLocalizations.of(context);
    final topOffers = content.offers.take(5).toList(growable: false);
    final forYouOffers = content.offers.skip(5).toList(growable: false);

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
                delegate: _HomeHeaderDelegate(
                  topInset: MediaQuery.paddingOf(context).top,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.sm,
                  AppSpacing.screenHorizontal,
                  AppSpacing.shellScrollBottom,
                ),
                sliver: SliverList.list(
                  children: [
                    HomeStoryStrip(
                      stories: content.stories,
                      onSeeAll: () =>
                          context.push(AppRoutes.homeSeeAll('stories')),
                    ),
                    if (topOffers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeOffersPreviewSection(
                        title: l10n.homeSectionTopOffersTitle,
                        subtitle: l10n.homeSectionTopOffersSubtitle,
                        offers: topOffers,
                        layout: HomeOfferPreviewLayout.hero,
                        onSeeAll: () =>
                            context.push(AppRoutes.homeSeeAll('offers')),
                      ),
                    ],
                    if (forYouOffers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      HomeOffersPreviewSection(
                        offers: forYouOffers,
                        onSeeAll: () =>
                            context.push(AppRoutes.homeSeeAll('for_you')),
                      ),
                    ],
                    if (content.highlight != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      PromooSectionHeader(
                        title: l10n.homeSectionPromooOfDayTitle,
                        subtitle: l10n.homeSectionPromooOfDaySubtitle,
                        actionLabel: l10n.commonSeeAll,
                        onActionPressed: () =>
                            context.push(AppRoutes.homeSeeAll('offers')),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HomeHighlightCard(
                        highlight: content.highlight!,
                        onTap: () {
                          context.push(
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
                      HomeServicesPreviewSection(
                        services: content.services,
                        onSeeAll: () => context.go(AppRoutes.services),
                      ),
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

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeHeaderDelegate({required this.topInset});

  final double topInset;

  @override
  double get minExtent => topInset + 56;

  @override
  double get maxExtent => topInset + 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return HomeHeader(isScrolled: overlapsContent || shrinkOffset > 0);
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.topInset != topInset;
  }
}
