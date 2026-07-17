import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/saved_dto.dart';
import 'saved_data_source.dart';

final savedRemoteDataSourceProvider = Provider<SavedRemoteDataSource>((ref) {
  return SavedRemoteDataSource(ref.watch(apiClientProvider));
});

class SavedRemoteDataSource implements SavedDataSource {
  const SavedRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SavedItemsDto> fetchSaved() async {
    final response = await _apiClient.get<SavedItemsDto>(
      ApiEndpoints.saved,
      decode: SavedItemsDto.fromJsonFlexible,
    );
    return response.data ?? SavedItemsDto.empty();
  }

  @override
  Future<void> removeSaved(String savedId) async {
    await _apiClient.delete<void>(
      ApiEndpoints.savedById(savedId),
      decode: (_) {},
    );
  }
}
