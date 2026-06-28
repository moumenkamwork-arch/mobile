import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/search/data/datasources/search_data_source.dart';
import 'package:promoo_app/features/search/data/datasources/search_fake_data_source.dart';
import 'package:promoo_app/features/search/data/dto/search_dto.dart';
import 'package:promoo_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:promoo_app/features/search/domain/entities/search_result.dart';

void main() {
  test('uses fake data source when mock fallback is enabled', () async {
    final repository = SearchRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: const SearchFakeDataSource(),
    );

    final result = await repository.search(query: 'studio');

    expect(result.isSuccess, isTrue);
    result.when(
      success: (page) {
        expect(page.results, isNotEmpty);
        expect(page.results.first.title, 'Saffron Social Studio');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      dto: const SearchResultsDto(
        results: [
          SearchResultDto(
            id: 'remote-service',
            type: SearchResultType.service,
            title: 'Remote service',
            price: 500,
          ),
        ],
      ),
    );
    final repository = SearchRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.search(
      query: 'remote',
      filter: SearchFilterType.services,
    );

    expect(remoteDataSource.lastQuery, 'remote');
    expect(remoteDataSource.lastFilter, SearchFilterType.services);
    result.when(
      success: (page) {
        expect(page.results.single, isA<SearchServiceResult>());
        expect(
          (page.results.single as SearchServiceResult).price?.label,
          '500 AED',
        );
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('maps API exceptions to failures', () async {
    final repository = SearchRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.network,
          message: 'No connection',
        ),
      ),
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.search(query: 'studio');

    expect(result.isFailure, isTrue);
    result.when(
      success: (page) => fail('Expected failure, got $page'),
      failure: (failure) => expect(failure.message, 'No connection'),
    );
  });
}

class _RecordingDataSource implements SearchDataSource {
  _RecordingDataSource({required this.dto});

  final SearchResultsDto dto;
  String? lastQuery;
  SearchFilterType? lastFilter;

  @override
  Future<SearchResultsDto> search({
    required String query,
    required SearchFilterType filter,
    int page = 1,
    int limit = 20,
  }) async {
    lastQuery = query;
    lastFilter = filter;
    return dto;
  }
}

class _ThrowingDataSource implements SearchDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<SearchResultsDto> search({
    required String query,
    required SearchFilterType filter,
    int page = 1,
    int limit = 20,
  }) {
    return Future<SearchResultsDto>.error(error);
  }
}
