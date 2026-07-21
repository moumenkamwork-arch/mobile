import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../i18n/locale_controller.dart';
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
  var _allServices = const <PromooService>[];

  @override
  ServicesState build() {
    // Categories carry a single server-resolved `name` (via Accept-Language) —
    // watching the locale forces a full rebuild (fresh categories + services
    // fetch) whenever the language toggle changes, instead of leaving this
    // controller's one-time fetch frozen in whatever language was active on
    // first load.
    ref.watch(localeProvider);
    // `build()` reruns (same instance) on every locale change, since a plain
    // Notifier is never recreated on a watched-value change. `_disposed` must
    // be reset here too, otherwise the *previous* build's onDispose (which
    // fires right before this rerun) leaves it permanently `true`, silently
    // dropping every future `_load()` result after the first locale switch.
    _disposed = false;
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
    return _applyFilters(
      selectedCategoryId: categoryId,
      updateSelectedCategory: true,
      searchQuery: state.searchQuery,
    );
  }

  Future<void> search(String query) {
    return _applyFilters(
      selectedCategoryId: state.selectedCategoryId,
      searchQuery: query.trim(),
    );
  }

  Future<void> clearSearch() {
    return _applyFilters(
      selectedCategoryId: state.selectedCategoryId,
      searchQuery: '',
    );
  }

  /// Leaves the results layer entirely: clears the selected category and any
  /// search query, returning the screen to the category grid. Used by the
  /// in-app results back affordance and the system back button.
  Future<void> clearFilters() {
    return _applyFilters(
      selectedCategoryId: null,
      updateSelectedCategory: true,
      searchQuery: '',
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

    final servicesResult = await repository.getServices();
    if (_disposed) {
      return;
    }

    servicesResult.when(
      success: (services) {
        _allServices = services;
        _emitFilteredState(
          categories: categories,
          selectedCategoryId: nextSelectedCategoryId,
          searchQuery: nextSearchQuery,
        );
      },
      failure: (failure) {
        state = ServicesState.error(
          failure: failure,
          categories: categories,
          services: refreshing ? previousServices : const [],
          selectedCategoryId: nextSelectedCategoryId,
          searchQuery: nextSearchQuery,
        );
      },
    );
  }

  Future<void> _applyFilters({
    String? selectedCategoryId,
    bool updateSelectedCategory = false,
    String? searchQuery,
  }) async {
    final nextSelectedCategoryId = updateSelectedCategory
        ? selectedCategoryId
        : state.selectedCategoryId;
    final nextSearchQuery = searchQuery ?? state.searchQuery;

    if (_allServices.isEmpty && state.status == ServicesStatus.loading) {
      return;
    }

    _emitFilteredState(
      categories: state.categories,
      selectedCategoryId: nextSelectedCategoryId,
      searchQuery: nextSearchQuery,
    );
  }

  void _emitFilteredState({
    required List<ServiceCategory> categories,
    required String? selectedCategoryId,
    required String searchQuery,
  }) {
    final filtered = _filteredServices(
      selectedCategoryId: selectedCategoryId,
      searchQuery: searchQuery,
    );

    if (filtered.isEmpty) {
      state = ServicesState.empty(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        searchQuery: searchQuery,
      );
      return;
    }

    state = ServicesState.success(
      categories: categories,
      services: filtered,
      selectedCategoryId: selectedCategoryId,
      searchQuery: searchQuery,
    );
  }

  List<PromooService> _filteredServices({
    required String? selectedCategoryId,
    required String searchQuery,
  }) {
    final query = searchQuery.trim().toLowerCase();
    return [
      for (final service in _allServices)
        if (_matchesCategory(service, selectedCategoryId) &&
            _matchesSearch(service, query))
          service,
    ];
  }

  bool _matchesCategory(PromooService service, String? selectedCategoryId) {
    if (selectedCategoryId == null || selectedCategoryId.trim().isEmpty) {
      return true;
    }
    return service.category?.id == selectedCategoryId;
  }

  bool _matchesSearch(PromooService service, String query) {
    if (query.isEmpty) {
      return true;
    }

    final values = [
      service.title,
      service.description,
      service.category?.name,
      service.category?.nameEn,
      service.category?.nameAr,
      service.category?.slug,
      service.provider?.name,
      service.provider?.username,
      service.location,
      ...service.tags,
    ];

    return values.whereType<String>().any(
      (value) => value.toLowerCase().contains(query),
    );
  }
}
