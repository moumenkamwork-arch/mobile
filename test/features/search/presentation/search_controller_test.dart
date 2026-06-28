import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:promoo_app/features/search/domain/entities/search_result.dart';
import 'package:promoo_app/features/search/domain/repositories/search_repository.dart';
import 'package:promoo_app/features/search/presentation/controllers/search_controller.dart';

void main() {
  test('starts idle and ignores short queries', () async {
    final container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(
          const _SearchRepository(result: Result.success(_successPage)),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(searchControllerProvider).status, SearchStatus.idle);

    await container.read(searchControllerProvider.notifier).submitSearch('n');

    final state = container.read(searchControllerProvider);
    expect(state.status, SearchStatus.idle);
    expect(state.hasShortQuery, isTrue);
  });

  test('emits loading then success', () async {
    final repository = const _SearchRepository(
      result: Result.success(_successPage),
    );
    final container = ProviderContainer(
      overrides: [searchRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final future = container
        .read(searchControllerProvider.notifier)
        .submitSearch('saffron');

    expect(
      container.read(searchControllerProvider).status,
      SearchStatus.loading,
    );

    await future;

    final state = container.read(searchControllerProvider);
    expect(state.status, SearchStatus.success);
    expect(state.results.single.title, 'Saffron Social Studio');
  });

  test('emits empty when repository returns no results', () async {
    final container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(
          const _SearchRepository(
            result: Result.success(SearchResultsPage(results: [])),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(searchControllerProvider.notifier)
        .submitSearch('none');

    expect(container.read(searchControllerProvider).status, SearchStatus.empty);
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(
          const _SearchRepository(
            result: Result.failure(
              AppFailure.network(message: 'No connection'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(searchControllerProvider.notifier)
        .submitSearch('saffron');

    final state = container.read(searchControllerProvider);
    expect(state.status, SearchStatus.error);
    expect(state.failure?.message, 'No connection');
  });

  test(
    'selects influencer filter using confirmed backend account type intent',
    () async {
      final repository = _SearchRepository(
        result: const Result.success(_successPage),
      );
      final container = ProviderContainer(
        overrides: [searchRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      container.read(searchControllerProvider.notifier).updateQuery('lina');
      await container
          .read(searchControllerProvider.notifier)
          .selectFilter(SearchFilterType.influencers);

      expect(repository.lastFilter, SearchFilterType.influencers);
      expect(
        container.read(searchControllerProvider).selectedFilter,
        SearchFilterType.influencers,
      );
    },
  );
}

const _successPage = SearchResultsPage(
  results: [
    SearchProfileResult(
      id: 'profile-saffron-social',
      title: 'Saffron Social Studio',
      username: 'saffron.social',
      isVerified: true,
    ),
  ],
);

class _SearchRepository implements SearchRepository {
  const _SearchRepository({required this.result});

  final Result<SearchResultsPage> result;
  static SearchFilterType? _lastFilter;

  SearchFilterType? get lastFilter => _lastFilter;

  @override
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter = SearchFilterType.all,
    int page = 1,
    int limit = 20,
  }) async {
    _lastFilter = filter;
    return result;
  }
}
