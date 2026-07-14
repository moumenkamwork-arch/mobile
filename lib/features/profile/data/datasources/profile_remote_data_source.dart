import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/promoo_profile.dart';
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
    return response.data ?? const PromooProfileDto();
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() async {
    final response = await _apiClient.get<PromooProfileDto>(
      ApiEndpoints.myProfile,
      decode: PromooProfileDto.fromJsonFlexible,
    );
    return response.data ?? const PromooProfileDto();
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) async {
    // Content packages were never a real backend entity (see
    // docs/v2_deferred_scope.md §2) — nothing to fetch.
    return ProfilePackagesDto.empty();
  }

  @override
  Future<PromooProfileDto> updateMyProfile(ProfileUpdateDraft draft) async {
    final body = <String, Object?>{
      if (draft.displayName != null) 'full_name': draft.displayName,
      if (draft.username != null) 'username': draft.username,
      if (draft.bio != null) 'bio': draft.bio,
      if (draft.location != null) 'location': draft.location,
      if (draft.website != null) 'website': draft.website,
    };

    final response = await _apiClient.put<PromooProfileDto>(
      ApiEndpoints.myProfile,
      data: body,
      decode: PromooProfileDto.fromJsonFlexible,
    );
    return response.data ?? const PromooProfileDto();
  }
}
