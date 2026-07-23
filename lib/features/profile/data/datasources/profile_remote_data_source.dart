import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/follow_user.dart';
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
      if (draft.categoryId != null) 'category_id': draft.categoryId,
    };

    final response = await _apiClient.put<PromooProfileDto>(
      ApiEndpoints.myProfile,
      data: body,
      decode: PromooProfileDto.fromJsonFlexible,
    );
    return response.data ?? const PromooProfileDto();
  }

  @override
  Future<PromooProfileDto> updateMyAvatar(String avatarUrl) async {
    final response = await _apiClient.post<PromooProfileDto>(
      ApiEndpoints.myAvatar,
      data: {'avatar_url': avatarUrl},
      decode: PromooProfileDto.fromJsonFlexible,
    );
    return response.data ?? const PromooProfileDto();
  }

  @override
  Future<PromooProfileDto> updateMyCover(String coverUrl) async {
    final response = await _apiClient.post<PromooProfileDto>(
      ApiEndpoints.myCover,
      data: {'cover_url': coverUrl},
      decode: PromooProfileDto.fromJsonFlexible,
    );
    return response.data ?? const PromooProfileDto();
  }

  @override
  Future<bool> fetchFollowStatus(String profileId) async {
    final response = await _apiClient.get<bool>(
      ApiEndpoints.followStatus(profileId),
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : null;
        return map?['isFollowing'] == true || map?['is_following'] == true;
      },
    );
    return response.data ?? false;
  }

  @override
  Future<void> followProfile(String profileId) async {
    await _apiClient.post<void>(
      ApiEndpoints.follow(profileId),
      decode: (_) {},
    );
  }

  @override
  Future<void> unfollowProfile(String profileId) async {
    await _apiClient.delete<void>(
      ApiEndpoints.follow(profileId),
      decode: (_) {},
    );
  }

  @override
  Future<List<FollowUser>> fetchFollowing(String profileId) async {
    final response = await _apiClient.get<List<FollowUser>>(
      ApiEndpoints.followingList(profileId),
      decode: _parseFollowUsers,
    );
    return response.data ?? const [];
  }

  @override
  Future<List<FollowUser>> fetchFollowers(String profileId) async {
    final response = await _apiClient.get<List<FollowUser>>(
      ApiEndpoints.followersList(profileId),
      decode: _parseFollowUsers,
    );
    return response.data ?? const [];
  }

  @override
  Future<bool> fetchBlockStatus(String profileId) async {
    final response = await _apiClient.get<bool>(
      ApiEndpoints.blockStatus(profileId),
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : null;
        return map?['isBlocked'] == true || map?['is_blocked'] == true;
      },
    );
    return response.data ?? false;
  }

  @override
  Future<void> blockProfile(String profileId) async {
    await _apiClient.post<void>(
      ApiEndpoints.block(profileId),
      decode: (_) {},
    );
  }

  @override
  Future<void> unblockProfile(String profileId) async {
    await _apiClient.delete<void>(
      ApiEndpoints.block(profileId),
      decode: (_) {},
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.delete<void>(ApiEndpoints.myProfile, decode: (_) {});
  }

  @override
  Future<void> deleteMedia(String imageUrl) async {
    await _apiClient.delete<void>(
      ApiEndpoints.uploadMedia,
      data: {'url': imageUrl},
      decode: (_) {},
    );
  }

  @override
  Future<List<FollowUser>> fetchBlockedUsers() async {
    final response = await _apiClient.get<List<FollowUser>>(
      ApiEndpoints.blocks,
      decode: _parseFollowUsers,
    );
    return response.data ?? const [];
  }

  /// Each `GET /follows/following/:id` row is `{created_at, following:{...}}`
  /// (followers use `follower`, `GET /blocks` uses `blocked`) — pull the
  /// nested profile defensively.
  static List<FollowUser> _parseFollowUsers(Object? data) {
    final list = data is List
        ? data
        : (data is Map ? data['data'] : null);
    if (list is! List) return const [];

    final users = <FollowUser>[];
    for (final row in list) {
      final map = row is Map ? Map<String, Object?>.from(row) : null;
      if (map == null) continue;
      final nested =
          map['following'] ??
          map['follower'] ??
          map['blocked'] ??
          map['profile'] ??
          map['user'] ??
          map;
      final profile = nested is Map ? Map<String, Object?>.from(nested) : null;
      final id = profile?['id'];
      if (profile == null || id is! String || id.isEmpty) continue;

      users.add(
        FollowUser(
          id: id,
          name: (profile['full_name'] ?? profile['username'] ?? 'Promoo user')
              as String,
          username: profile['username'] as String?,
          avatarUrl: profile['avatar_url'] as String?,
          accountType: profile['account_type'] as String?,
        ),
      );
    }
    return users;
  }
}
