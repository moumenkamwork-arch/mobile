import '../../../../core/utils/result.dart';
import '../entities/saved_item.dart';

abstract interface class SavedRepository {
  Future<Result<List<SavedItem>>> getSavedItems();

  Future<Result<void>> removeSavedItem(String savedId);
}
