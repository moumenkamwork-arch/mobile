import '../../../../core/utils/result.dart';
import '../entities/saved_item.dart';

abstract interface class SavedRepository {
  Future<Result<List<SavedItem>>> getSavedItems();

  /// `POST /saved`. Returns the new saved-row id (used later for removal).
  Future<Result<String>> addSavedItem({
    required String itemId,
    required String itemType,
  });

  Future<Result<void>> removeSavedItem(String savedId);
}
