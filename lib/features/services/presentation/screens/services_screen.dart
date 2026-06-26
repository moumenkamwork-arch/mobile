import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_service.dart';
import '../controllers/services_controller.dart';
import '../widgets/service_card.dart';
import '../widgets/services_category_list.dart';
import '../widgets/services_search_field.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error),
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
                    Text(
                      'Services',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Discover listings and contact providers.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ServicesSearchField(
                      query: state.searchQuery,
                      onSubmitted: (query) {
                        ref
                            .read(servicesControllerProvider.notifier)
                            .search(query);
                      },
                      onClear: state.searchQuery.isEmpty
                          ? null
                          : () => ref
                                .read(servicesControllerProvider.notifier)
                                .clearSearch(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ServicesCategoryList(
                      categories: state.categories,
                      selectedCategoryId: state.selectedCategoryId,
                      onSelected: (categoryId) {
                        ref
                            .read(servicesControllerProvider.notifier)
                            .selectCategory(categoryId);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.services.isEmpty)
                      _ServicesEmptyState(
                        selectedCategoryId: state.selectedCategoryId,
                        query: state.searchQuery,
                      )
                    else
                      _ServicesList(services: state.services),
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
            onTap: () => context.go(AppRoutes.serviceById(services[i].id)),
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
      title: filtered ? 'No services found' : 'No services yet',
      message: filtered
          ? 'Try another category or search term.'
          : 'Service listings will appear here when they are available.',
    );
  }
}
