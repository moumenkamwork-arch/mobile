import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_data_source.dart';
import '../datasources/search_remote_data_source.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    config: ref.watch(appConfigProvider),
    dataSource: ref.watch(searchRemoteDataSourceProvider),
  );
});

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl({required this.config, required this.dataSource});

  final AppConfig config;
  final SearchDataSource dataSource;

  @override
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter = SearchFilterType.all,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final dto = await dataSource.search(
        query: query,
        filter: filter,
        page: page,
        limit: limit,
      );
      return Result.success(
        dto.toDomain(fallbackCurrency: config.fallbackCurrency),
      );
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
