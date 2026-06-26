import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/profile_dto.dart';
import 'profile_data_source.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(ref.watch(apiClientProvider));
});

class ProfileRemoteDataSource implements ProfileDataSource {
  const ProfileRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<PromooProfileDto> fetchProfile(String idOrUsername) async {
    final response = await _apiClient.get<PromooProfileDto>(
      ApiEndpoints.profileByIdOrUsername(idOrUsername),
      decode: PromooProfileDto.fromJsonFlexible,
    );

    final profile = response.data;
    if (profile == null || !profile.hasIdentity) {
      throw const FormatException('Expected profile detail object.');
    }
    return profile;
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() async {
    final response = await _apiClient.get<PromooProfileDto>(
      ApiEndpoints.myProfile,
      decode: PromooProfileDto.fromJsonFlexible,
    );

    final profile = response.data;
    if (profile == null || !profile.hasIdentity) {
      throw const FormatException('Expected profile detail object.');
    }
    return profile;
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) async {
    if (profileId.trim().isEmpty) {
      return ProfilePackagesDto.empty();
    }

    // The current backend does not expose a profileId/profile_id filter for
    // GET /services. Fetch the public first page and filter by nested profile.
    final response = await _apiClient.get<ProfilePackagesDto>(
      ApiEndpoints.services,
      decode: ProfilePackagesDto.fromJsonFlexible,
    );

    return response.data ?? ProfilePackagesDto.empty();
  }
}
