import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/saved_item.dart';
import '../../domain/repositories/saved_repository.dart';
import '../datasources/saved_data_source.dart';
import '../datasources/saved_remote_data_source.dart';

final savedRepositoryProvider = Provider<SavedRepository>((ref) {
  return SavedRepositoryImpl(dataSource: ref.watch(savedRemoteDataSourceProvider));
});

class SavedRepositoryImpl implements SavedRepository {
  const SavedRepositoryImpl({required this.dataSource});

  final SavedDataSource dataSource;

  @override
  Future<Result<List<SavedItem>>> getSavedItems() async {
    try {
      final dto = await dataSource.fetchSaved();
      return Result.success(dto.toDomain());
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<String>> addSavedItem({
    required String itemId,
    required String itemType,
  }) async {
    try {
      final id = await dataSource.addSaved(itemId: itemId, itemType: itemType);
      return Result.success(id);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> removeSavedItem(String savedId) async {
    try {
      await dataSource.removeSaved(savedId);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
