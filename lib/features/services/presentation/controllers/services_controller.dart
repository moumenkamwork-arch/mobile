import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/services_repository_impl.dart';
import '../../domain/entities/promoo_service.dart';

final servicesControllerProvider =
    NotifierProvider<ServicesController, ServicesState>(ServicesController.new);

enum ServicesStatus { loading, success, empty, error, refreshing }

class ServicesState {
  const ServicesState({
    required this.status,
    this.categories = const [],
    this.services = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.failure,
  });

  const ServicesState.loading() : this(status: ServicesStatus.loading);

  const ServicesState.success({
    required List<ServiceCategory> categories,
    required List<PromooService> services,
    String? selectedCategoryId,
    String searchQuery = '',
  }) : this(
         status: ServicesStatus.success,
         categories: categories,
         services: services,
         selectedCategoryId: selectedCategoryId,
         searchQuery: searchQuery,
       );

  const ServicesState.empty({
    required List<ServiceCategory> categories,
    String? selectedCategoryId,
    String searchQuery = '',
  }) : this(
         status: ServicesStatus.empty,
         categories: categories,
         selectedCategoryId: selectedCategoryId,
         searchQuery: searchQuery,
       );

  const ServicesState.error({
    required AppFailure failure,
    List<ServiceCategory> categories = const [],
    List<PromooService> services = const [],
    String? selectedCategoryId,
    String searchQuery = '',
  }) : this(
         status: ServicesStatus.error,
         failure: failure,
         categories: categories,
         services: services,
         selectedCategoryId: selectedCategoryId,
         searchQuery: searchQuery,
       );

  const ServicesState.refreshing({
    required List<ServiceCategory> categories,
    required List<PromooService> services,
    String? selectedCategoryId,
    String searchQuery = '',
  }) : this(
         status: ServicesStatus.refreshing,
         categories: categories,
         services: services,
         selectedCategoryId: selectedCategoryId,
         searchQuery: searchQuery,
       );

  final ServicesStatus status;
  final List<ServiceCategory> categories;
  final List<PromooService> services;
  final String? selectedCategoryId;
  final String searchQuery;
  final AppFailure? failure;

  bool get isRefreshing => status == ServicesStatus.refreshing;

  bool get hasContent => services.isNotEmpty;
}

class ServicesController extends Notifier<ServicesState> {
  var _disposed = false;

  @override
  ServicesState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const ServicesState.loading();
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return _load(showLoading: true);
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  Future<void> selectCategory(String? categoryId) {
    return _load(
      selectedCategoryId: categoryId,
      updateSelectedCategory: true,
      searchQuery: state.searchQuery,
      refreshing: true,
    );
  }

  Future<void> search(String query) {
    return _load(
      selectedCategoryId: state.selectedCategoryId,
      searchQuery: query.trim(),
      refreshing: true,
    );
  }

  Future<void> clearSearch() {
    return _load(
      selectedCategoryId: state.selectedCategoryId,
      searchQuery: '',
      refreshing: true,
    );
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
    String? selectedCategoryId,
    bool updateSelectedCategory = false,
    String? searchQuery,
  }) async {
    final nextSelectedCategoryId = updateSelectedCategory
        ? selectedCategoryId
        : state.selectedCategoryId;
    final nextSearchQuery = searchQuery ?? state.searchQuery;
    final previousCategories = state.categories;
    final previousServices = state.services;

    if (refreshing) {
      state = ServicesState.refreshing(
        categories: previousCategories,
        services: previousServices,
        selectedCategoryId: nextSelectedCategoryId,
        searchQuery: nextSearchQuery,
      );
    } else if (showLoading) {
      state = const ServicesState.loading();
    }

    final repository = ref.read(servicesRepositoryProvider);
    final categoriesResult = previousCategories.isEmpty
        ? await repository.getCategories()
        : null;
    if (_disposed) {
      return;
    }

    final categories = categoriesResult == null
        ? previousCategories
        : categoriesResult.when(
            success: (items) => items,
            failure: (failure) {
              state = ServicesState.error(
                failure: failure,
                categories: previousCategories,
                services: previousServices,
                selectedCategoryId: nextSelectedCategoryId,
                searchQuery: nextSearchQuery,
              );
              return previousCategories;
            },
          );

    if (categoriesResult?.isFailure ?? false) {
      return;
    }

    final servicesResult = await repository.getServices(
      categoryId: nextSelectedCategoryId,
      query: nextSearchQuery,
    );
    if (_disposed) {
      return;
    }

    state = servicesResult.when(
      success: (services) {
        if (services.isEmpty) {
          return ServicesState.empty(
            categories: categories,
            selectedCategoryId: nextSelectedCategoryId,
            searchQuery: nextSearchQuery,
          );
        }
        return ServicesState.success(
          categories: categories,
          services: services,
          selectedCategoryId: nextSelectedCategoryId,
          searchQuery: nextSearchQuery,
        );
      },
      failure: (failure) {
        return ServicesState.error(
          failure: failure,
          categories: categories,
          services: refreshing ? previousServices : const [],
          selectedCategoryId: nextSelectedCategoryId,
          searchQuery: nextSearchQuery,
        );
      },
    );
  }
}
