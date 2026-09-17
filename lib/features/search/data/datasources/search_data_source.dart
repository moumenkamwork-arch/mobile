import '../../domain/entities/search_result.dart';
import '../dto/search_dto.dart';

abstract interface class SearchDataSource {
  Future<SearchResultsDto> search({
    required String query,
    required SearchFilterType filter,
    int page = 1,
    int limit = 20,
  });
}
