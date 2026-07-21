/// The Supabase Storage bucket a file lands in. The backend groups uploads by
/// bucket for organization + per-bucket policies, so the app must pick the
/// bucket that matches what the file is for — never leave it to the `general`
/// default when a dedicated bucket exists. Mirrors the backend's
/// `UploadService` `BucketName` union (`upload.service.ts`).
enum UploadBucket {
  avatars('avatars'),
  covers('covers'),
  offers('offers'),
  ads('ads'),
  chatMedia('chat-media'),
  services('services'),
  stories('stories'),
  verifications('verifications'),
  reports('reports'),
  general('general');

  const UploadBucket(this.apiValue);

  /// The exact string the backend's `bucket` field expects.
  final String apiValue;
}

/// What an uploaded file is attached to. Written onto the `media` row's
/// `related_to` so the backend can group a profile's media, an offer's images,
/// etc. Mirrors the backend's `RelatedTo` union (`upload.service.ts`).
enum UploadRelatedTo {
  profile('profile'),
  offer('offer'),
  ad('ad'),
  chat('chat'),
  service('service'),
  story('story'),
  report('report'),
  verification('verification');

  const UploadRelatedTo(this.apiValue);

  final String apiValue;
}

/// A file that has been uploaded to Supabase Storage via `POST /upload/*`.
/// The canonical thing the app keeps is [fileUrl] — a public storage link it
/// then stores on whatever entity the file belongs to (profile avatar, offer
/// image, …). The app never holds raw bytes past the upload call.
class UploadedMedia {
  const UploadedMedia({
    required this.id,
    required this.fileUrl,
    this.fileName,
    this.fileType,
    this.fileSize,
  });

  final String id;
  final String fileUrl;
  final String? fileName;
  final String? fileType;
  final int? fileSize;

  /// Parses the `media` record the upload endpoints return under `data`.
  /// Defensive: the only field the app truly needs is `file_url`, so a missing
  /// one is treated as a parse failure by the caller (empty url).
  static UploadedMedia fromJson(Object? data) {
    final map = data is Map ? Map<String, Object?>.from(data) : const {};
    return UploadedMedia(
      id: (map['id'] as String?) ?? '',
      fileUrl: (map['file_url'] ?? map['fileUrl'] ?? '') as String,
      fileName: map['file_name'] as String?,
      fileType: map['file_type'] as String?,
      fileSize: map['file_size'] is num ? (map['file_size']! as num).toInt() : null,
    );
  }
}
