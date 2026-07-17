import '../dto/saved_dto.dart';

abstract interface class SavedDataSource {
  Future<SavedItemsDto> fetchSaved();

  Future<void> removeSaved(String savedId);
}
