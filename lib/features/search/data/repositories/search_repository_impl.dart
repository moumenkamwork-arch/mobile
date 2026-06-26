import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_data_source.dart';
import '../datasources/search_fake_data_source.dart';
import '../datasources/search_remote_data_source.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(searchRemoteDataSourceProvider),
    fakeDataSource: ref.watch(searchFakeDataSourceProvider),
  );
});

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final AppConfig config;
  final SearchDataSource remoteDataSource;
  final SearchDataSource fakeDataSource;

  SearchDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter = SearchFilterType.all,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final dto = await _activeDataSource.search(
        query: query,
        filter: filter,
        page: page,
        limit: limit,
      );
      return Result.success(
        dto.toDomain(fallbackCurrency: config.fallbackCurrency),
      );
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
