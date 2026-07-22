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
  Future<String> addSaved({
    required String itemId,
    required String itemType,
  }) async {
    final response = await _apiClient.post<String>(
      ApiEndpoints.saved,
      data: {'item_id': itemId, 'item_type': itemType},
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : const {};
        return (map['id'] as String?) ?? '';
      },
    );
    return response.data ?? '';
  }

  @override
  Future<void> removeSaved(String savedId) async {
    await _apiClient.delete<void>(
      ApiEndpoints.savedById(savedId),
      decode: (_) {},
    );
  }
}
