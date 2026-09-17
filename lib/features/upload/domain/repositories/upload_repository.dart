import '../../../../core/utils/result.dart';
import '../entities/uploaded_media.dart';

/// Uploads a locally-picked file to the backend, which stores it in Supabase
/// Storage and returns a public URL. Every image/avatar/cover/offer picture in
/// the app goes through here — the two-step flow is always: upload here to get
/// a URL, then persist that URL on the owning entity via its own endpoint.
abstract interface class UploadRepository {
  /// Uploads an image (jpeg/png/webp/gif) to [bucket]. [relatedTo] tags the
  /// resulting `media` row; [relatedId] links it to an existing entity when one
  /// already exists (usually null — the entity is created *after* the upload).
  Future<Result<UploadedMedia>> uploadImage({
    required String filePath,
    required UploadBucket bucket,
    UploadRelatedTo? relatedTo,
    String? relatedId,
  });
}
