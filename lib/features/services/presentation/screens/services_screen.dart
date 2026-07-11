import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/back_interceptors.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_service.dart';
import '../controllers/services_controller.dart';
import '../widgets/service_card.dart';
import '../widgets/services_category_list.dart';
import '../widgets/services_search_field.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  VoidCallback? _unregisterBackInterceptor;

  @override
  void initState() {
    super.initState();
    // The results layer (category selected / search active) is a back step:
    // system back returns to the category grid before leaving the tab.
    _unregisterBackInterceptor = ref
        .read(backInterceptorsProvider)
        .register(_handleBack);
  }

  @override
  void dispose() {
    _unregisterBackInterceptor?.call();
    super.dispose();
  }

  bool _handleBack() {
    final state = ref.read(servicesControllerProvider);
    if (!_shouldShowResults(state)) {
      return false;
    }
    ref.read(servicesControllerProvider.notifier).clearFilters();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesControllerProvider);

    return switch (state.status) {
      ServicesStatus.loading => const PromooLoadingIndicator(
        message: 'Loading services',
      ),
      ServicesStatus.error => _ServicesErrorView(state: state),
      ServicesStatus.empty ||
      ServicesStatus.success ||
      ServicesStatus.refreshing => _ServicesContentView(
        state: state,
        onRefresh: () =>
            ref.read(servicesControllerProvider.notifier).refresh(),
      ),
    };
  }
}

class _ServicesErrorView extends ConsumerWidget {
  const _ServicesErrorView({required this.state});

  final ServicesState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.hasContent) {
      return Stack(
        children: [
          _ServicesContentView(
            state: state,
            onRefresh: () =>
                ref.read(servicesControllerProvider.notifier).refresh(),
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
                  state.failure?.message ?? 'Could not refresh services.',
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
      title: 'Could not load services',
      message: state.failure?.message ?? 'Something went wrong. Try again.',
      onRetry: () => ref.read(servicesControllerProvider.notifier).retry(),
    );
  }
}

class _ServicesContentView extends ConsumerWidget {
  const _ServicesContentView({required this.state, required this.onRefresh});

  final ServicesState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showResults = _shouldShowResults(state);
    final topInset = MediaQuery.paddingOf(context).top;

    // The header is a pinned sliver so the content scrolls *under* it and the
    // bar frosts on scroll (matching Home). It paints its own status-bar inset
    // so the chrome band reaches the top edge in both themes.
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
                    ServicesSearchField(
                      query: state.searchQuery,
                      onChanged: (query) => ref
                          .read(servicesControllerProvider.notifier)
                          .search(query),
                      onSubmitted: (query) => ref
                          .read(servicesControllerProvider.notifier)
                          .search(query),
                      onClear: state.searchQuery.isEmpty
                          ? null
                          : () => ref
                                .read(servicesControllerProvider.notifier)
                                .clearSearch(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (showResults) ...[
                      _ResultsContextBar(
                        state: state,
                        onBackToCategories: () => ref
                            .read(servicesControllerProvider.notifier)
                            .clearFilters(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (state.services.isEmpty)
                        _ServicesEmptyState(
                          selectedCategoryId: state.selectedCategoryId,
                          query: state.searchQuery,
                        )
                      else
                        _ServicesList(services: state.services),
                    ] else
                      ServicesCategoryList(
                        categories: state.categories,
                        selectedCategoryId: state.selectedCategoryId,
                        onSelected: (categoryId) {
                          ref
                              .read(servicesControllerProvider.notifier)
                              .selectCategory(categoryId);
                        },
                      ),
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

bool _shouldShowResults(ServicesState state) {
  return state.searchQuery.trim().isNotEmpty ||
      state.selectedCategoryId != null;
}

/// Step header shown above results: names the active category (or search)
/// and offers an explicit back step to the category grid — mirroring what
/// the system back button does at this layer.
class _ResultsContextBar extends StatelessWidget {
  const _ResultsContextBar({
    required this.state,
    required this.onBackToCategories,
  });

  final ServicesState state;
  final VoidCallback onBackToCategories;

  @override
  Widget build(BuildContext context) {
    final categoryName = _selectedCategoryName(state);
    final title = categoryName ?? 'Search results';
    final count = state.services.length;
    final countLabel = switch (count) {
      0 => 'No services',
      1 => '1 service',
      _ => '$count services',
    };

    return Row(
      children: [
        IconButton(
          tooltip: 'Back to categories',
          onPressed: onBackToCategories,
          icon: Icon(Icons.arrow_back_rounded, color: context.colors.accent),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(countLabel, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  String? _selectedCategoryName(ServicesState state) {
    final id = state.selectedCategoryId;
    if (id == null) {
      return null;
    }
    for (final category in state.categories) {
      if (category.id == id) {
        return category.name;
      }
    }
    return null;
  }
}

class _ServicesList extends StatelessWidget {
  const _ServicesList({required this.services});

  final List<PromooService> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < services.length; i++) ...[
          ServiceCard(
            service: services[i],
            onTap: () => context.push(AppRoutes.serviceById(services[i].id)),
          ),
          if (i != services.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ServicesEmptyState extends StatelessWidget {
  const _ServicesEmptyState({this.selectedCategoryId, required this.query});

  final String? selectedCategoryId;
  final String query;

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategoryId != null || query.isNotEmpty;
    return PromooEmptyState(
      title: filtered ? 'No service found.' : 'No services yet',
      message: filtered
          ? "We couldn't find this service yet."
          : 'Search or choose a category to discover services.',
    );
  }
}
