import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/uploaded_media.dart';
import '../../domain/repositories/upload_repository.dart';
import '../datasources/upload_remote_data_source.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepositoryImpl(ref.watch(uploadRemoteDataSourceProvider));
});

class UploadRepositoryImpl implements UploadRepository {
  const UploadRepositoryImpl(this._dataSource);

  final UploadRemoteDataSource _dataSource;

  @override
  Future<Result<UploadedMedia>> uploadImage({
    required String filePath,
    required UploadBucket bucket,
    UploadRelatedTo? relatedTo,
    String? relatedId,
  }) async {
    try {
      final media = await _dataSource.uploadImage(
        filePath: filePath,
        bucket: bucket,
        relatedTo: relatedTo,
        relatedId: relatedId,
      );
      if (media.fileUrl.isEmpty) {
        return const Result.failure(
          AppFailure.parsing(message: 'Upload returned no file URL.'),
        );
      }
      return Result.success(media);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
