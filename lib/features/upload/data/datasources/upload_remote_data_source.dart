import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/uploaded_media.dart';

final uploadRemoteDataSourceProvider = Provider<UploadRemoteDataSource>((ref) {
  return UploadRemoteDataSource(ref.watch(apiClientProvider));
});

class UploadRemoteDataSource {
  const UploadRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Posts the file as `multipart/form-data` to `POST /upload/image`. The field
  /// name MUST be `file` (the backend's multer is `upload.single('file')`);
  /// `bucket`/`related_to`/`related_id` ride alongside as form fields. Dio sets
  /// the multipart content-type + boundary automatically for a [FormData] body.
  Future<UploadedMedia> uploadImage({
    required String filePath,
    required UploadBucket bucket,
    UploadRelatedTo? relatedTo,
    String? relatedId,
  }) async {
    final fileName = filePath.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'bucket': bucket.apiValue,
      'related_to': ?relatedTo?.apiValue,
      'related_id': ?relatedId,
    });

    final response = await _apiClient.post<UploadedMedia>(
      ApiEndpoints.uploadImage,
      data: formData,
      decode: UploadedMedia.fromJson,
    );
    return response.data ??
        const UploadedMedia(id: '', fileUrl: '');
  }
}
