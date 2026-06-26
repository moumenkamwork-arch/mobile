import '../../../../core/utils/result.dart';
import '../entities/search_result.dart';

abstract interface class SearchRepository {
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter,
    int page,
    int limit,
  });
}
