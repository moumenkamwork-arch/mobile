import '../dto/saved_dto.dart';

abstract interface class SavedDataSource {
  Future<SavedItemsDto> fetchSaved();

  Future<String> addSaved({required String itemId, required String itemType});

  Future<void> removeSaved(String savedId);
}
