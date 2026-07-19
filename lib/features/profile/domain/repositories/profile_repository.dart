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

  Future<Result<bool>> getFollowStatus(String profileId);

  Future<Result<void>> followProfile(String profileId);

  Future<Result<void>> unfollowProfile(String profileId);
}
