import '../../domain/entities/promoo_profile.dart';
import '../dto/profile_dto.dart';

abstract interface class ProfileDataSource {
  Future<PromooProfileDto> fetchProfile(String idOrUsername);

  Future<PromooProfileDto> fetchMyProfile();

  Future<ProfilePackagesDto> fetchProfilePackages(String profileId);

  Future<PromooProfileDto> updateMyProfile(ProfileUpdateDraft draft);

  Future<bool> fetchFollowStatus(String profileId);

  Future<void> followProfile(String profileId);

  Future<void> unfollowProfile(String profileId);
}
