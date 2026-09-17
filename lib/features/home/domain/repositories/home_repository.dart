import '../../../../core/utils/result.dart';
import '../entities/home_content.dart';

abstract interface class HomeRepository {
  Future<Result<HomeContent>> getHomeContent();

  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  );

  /// `POST /stories` with a Supabase Storage URL already produced by the
  /// upload step (`bucket: UploadBucket.stories`, `related: UploadRelatedTo.story`).
  /// The backend defaults `expires_at` to 24h from now.
  Future<Result<void>> createStory(String mediaUrl);

  /// `DELETE /stories/:id` — backend checks ownership itself (403 if it's
  /// not yours), but the viewer only ever offers this for the signed-in
  /// user's own story group.
  Future<Result<void>> deleteStory(String storyId);
}
