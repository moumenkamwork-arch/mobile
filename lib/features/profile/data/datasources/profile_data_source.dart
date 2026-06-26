import '../dto/profile_dto.dart';

abstract interface class ProfileDataSource {
  Future<PromooProfileDto> fetchProfile(String idOrUsername);

  Future<PromooProfileDto> fetchMyProfile();

  Future<ProfilePackagesDto> fetchProfilePackages(String profileId);
}
