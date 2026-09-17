import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/search_result.dart';
import '../dto/search_dto.dart';
import 'search_data_source.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSource(ref.watch(apiClientProvider));
});

class SearchRemoteDataSource implements SearchDataSource {
  const SearchRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SearchResultsDto> search({
    required String query,
    required SearchFilterType filter,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, Object?>{
      'q': query,
      'type': filter.apiType,
      'page': page,
      'limit': limit,
      if (filter.accountType != null) 'accountType': filter.accountType,
    };

    final response = await _apiClient.get<SearchResultsDto>(
      ApiEndpoints.search,
      queryParameters: params,
      decode: (data) => SearchResultsDto.fromJsonFlexible(data, filter: filter),
    );

    return (response.data ?? SearchResultsDto.empty()).withMeta(response.meta);
  }
}
