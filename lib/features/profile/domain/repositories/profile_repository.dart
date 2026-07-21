import '../../../../core/utils/result.dart';
import '../entities/follow_user.dart';
import '../entities/promoo_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<List<FollowUser>>> getFollowing(String profileId);

  Future<Result<PromooProfile>> getDemoProfile();

  Future<Result<PromooProfile>> getProfile(String idOrUsername);

  Future<Result<PromooProfile>> getMyProfile();

  Future<Result<List<ProfilePackage>>> getProfilePackages(String profileId);

  Future<Result<PromooProfile>> updateMyProfile(ProfileUpdateDraft draft);

  /// Persists a Supabase Storage URL (from the Upload step) as the signed-in
  /// user's avatar via `POST /profiles/me/avatar` — separate from
  /// [updateMyProfile], which does not carry avatar/cover.
  Future<Result<PromooProfile>> updateMyAvatar(String avatarUrl);

  /// Same as [updateMyAvatar] for the cover image (`POST /profiles/me/cover`).
  Future<Result<PromooProfile>> updateMyCover(String coverUrl);

  Future<Result<bool>> getFollowStatus(String profileId);

  Future<Result<void>> followProfile(String profileId);

  Future<Result<void>> unfollowProfile(String profileId);
}
