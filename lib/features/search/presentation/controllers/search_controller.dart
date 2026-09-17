import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_result.dart';

final searchControllerProvider =
    NotifierProvider<SearchController, SearchState>(SearchController.new);

enum SearchStatus { idle, loading, success, empty, error, refreshing }

class SearchState {
  const SearchState({
    required this.status,
    this.query = '',
    this.selectedFilter = SearchFilterType.all,
    this.results = const [],
    this.failure,
  });

  const SearchState.idle({
    String query = '',
    SearchFilterType selectedFilter = SearchFilterType.all,
  }) : this(
         status: SearchStatus.idle,
         query: query,
         selectedFilter: selectedFilter,
       );

  const SearchState.loading({
    required String query,
    required SearchFilterType selectedFilter,
  }) : this(
         status: SearchStatus.loading,
         query: query,
         selectedFilter: selectedFilter,
       );

  const SearchState.success({
    required String query,
    required SearchFilterType selectedFilter,
    required List<SearchResult> results,
  }) : this(
         status: SearchStatus.success,
         query: query,
         selectedFilter: selectedFilter,
         results: results,
       );

  const SearchState.empty({
    required String query,
    required SearchFilterType selectedFilter,
  }) : this(
         status: SearchStatus.empty,
         query: query,
         selectedFilter: selectedFilter,
       );

  const SearchState.error({
    required String query,
    required SearchFilterType selectedFilter,
    required AppFailure failure,
    List<SearchResult> results = const [],
  }) : this(
         status: SearchStatus.error,
         query: query,
         selectedFilter: selectedFilter,
         failure: failure,
         results: results,
       );

  const SearchState.refreshing({
    required String query,
    required SearchFilterType selectedFilter,
    required List<SearchResult> results,
  }) : this(
         status: SearchStatus.refreshing,
         query: query,
         selectedFilter: selectedFilter,
         results: results,
       );

  final SearchStatus status;
  final String query;
  final SearchFilterType selectedFilter;
  final List<SearchResult> results;
  final AppFailure? failure;

  bool get isRefreshing => status == SearchStatus.refreshing;

  bool get hasContent => results.isNotEmpty;

  bool get hasShortQuery {
    final trimmed = query.trim();
    return trimmed.isNotEmpty &&
        trimmed.length < SearchController.minQueryLength;
  }
}

class SearchController extends Notifier<SearchState> {
  static const minQueryLength = 2;

  var _disposed = false;
  var _requestId = 0;

  @override
  SearchState build() {
    ref.onDispose(() {
      _disposed = true;
      _requestId++;
    });
    return const SearchState.idle();
  }

  void updateQuery(String query) {
    state = SearchState(
      status: state.status,
      query: query,
      selectedFilter: state.selectedFilter,
      results: state.results,
      failure: state.failure,
    );
  }

  Future<void> submitSearch([String? query]) {
    return _search(
      query: (query ?? state.query).trim(),
      filter: state.selectedFilter,
      showLoading: true,
    );
  }

  Future<void> selectFilter(SearchFilterType filter) {
    if (filter == state.selectedFilter) {
      return Future<void>.value();
    }

    final query = state.query.trim();
    if (query.length < minQueryLength) {
      state = SearchState.idle(query: state.query, selectedFilter: filter);
      return Future<void>.value();
    }

    return _search(query: query, filter: filter, showLoading: true);
  }

  Future<void> retry() {
    return _search(
      query: state.query.trim(),
      filter: state.selectedFilter,
      showLoading: true,
    );
  }

  Future<void> refresh() {
    return _search(
      query: state.query.trim(),
      filter: state.selectedFilter,
      refreshing: true,
    );
  }

  Future<void> clear() {
    _requestId++;
    state = SearchState.idle(selectedFilter: state.selectedFilter);
    return Future<void>.value();
  }

  Future<void> _search({
    required String query,
    required SearchFilterType filter,
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    _requestId++;

    if (query.length < minQueryLength) {
      state = SearchState.idle(query: query, selectedFilter: filter);
      return;
    }

    final requestId = _requestId;
    final previousResults = state.results;

    if (refreshing) {
      state = SearchState.refreshing(
        query: query,
        selectedFilter: filter,
        results: previousResults,
      );
    } else if (showLoading) {
      state = SearchState.loading(query: query, selectedFilter: filter);
    }

    final repository = ref.read(searchRepositoryProvider);
    final result = await repository.search(query: query, filter: filter);
    if (_disposed || requestId != _requestId) {
      return;
    }

    state = result.when(
      success: (page) {
        if (page.results.isEmpty) {
          return SearchState.empty(query: query, selectedFilter: filter);
        }
        return SearchState.success(
          query: query,
          selectedFilter: filter,
          results: page.results,
        );
      },
      failure: (failure) {
        return SearchState.error(
          query: query,
          selectedFilter: filter,
          failure: failure,
          results: refreshing ? previousResults : const [],
        );
      },
    );
  }
}
