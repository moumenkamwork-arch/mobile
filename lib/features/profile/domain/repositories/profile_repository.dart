import '../../../../core/utils/result.dart';
import '../entities/promoo_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<PromooProfile>> getDemoProfile();

  Future<Result<PromooProfile>> getProfile(String idOrUsername);

  Future<Result<PromooProfile>> getMyProfile();

  Future<Result<List<ProfilePackage>>> getProfilePackages(String profileId);

  Future<Result<PromooProfile>> updateMyProfile(ProfileUpdateDraft draft);
}
