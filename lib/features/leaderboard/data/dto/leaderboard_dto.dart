import '../../domain/entities/leaderboard_profile.dart';

class LeaderboardProfileDto {
  const LeaderboardProfileDto({
    this.id,
    this.rank,
    this.displayName,
    this.username,
    this.avatarUrl,
    this.bio,
    this.accountType,
    this.followersCount,
    this.score,
    this.badgeLabel,
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String? id;
  final int? rank;
  final String? displayName;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final String? accountType;
  final int? followersCount;
  final int? score;
  final String? badgeLabel;
  final bool isVerified;
  final bool isFeatured;

  factory LeaderboardProfileDto.fromJson(Map<String, Object?> json) {
    final nestedProfile =
        _mapFrom(json['profile']) ??
        _mapFrom(json['user']) ??
        _mapFrom(json['account']);
    final source = <String, Object?>{...?nestedProfile, ...json};

    final followersCount = _readInt(source, const [
      'followers_count',
      'followersCount',
      'follower_count',
      'followerCount',
      'followers',
    ]);

    return LeaderboardProfileDto(
      id: _readString(source, const [
        'id',
        'profile_id',
        'profileId',
        'user_id',
        'userId',
      ]),
      rank: _readInt(source, const ['rank', 'position', 'place']),
      displayName: _readString(source, const [
        'full_name',
        'fullName',
        'display_name',
        'displayName',
        'name',
        'username',
      ]),
      username: _readString(source, const ['username']),
      avatarUrl: _readString(source, const [
        'avatar_url',
        'avatarUrl',
        'image_url',
        'imageUrl',
        'avatar',
      ]),
      bio: _readString(source, const ['bio', 'description', 'summary']),
      accountType: _readString(source, const [
        'account_type',
        'accountType',
        'type',
      ]),
      followersCount: followersCount,
      score:
          _readInt(source, const [
            'score',
            'points',
            'total_score',
            'totalScore',
          ]) ??
          followersCount,
      badgeLabel: _readString(source, const [
        'badge',
        'badge_label',
        'badgeLabel',
        'tier',
        'label',
      ]),
      isVerified: _readBool(source, const ['is_verified', 'isVerified']),
      isFeatured: _readBool(source, const ['is_featured', 'isFeatured']),
    );
  }

  bool get hasIdentity {
    return id != null || displayName != null || username != null;
  }

  LeaderboardProfile toDomain({
    required String fallbackId,
    required int fallbackRank,
  }) {
    return LeaderboardProfile(
      id: id ?? fallbackId,
      rank: LeaderboardRank(rank ?? fallbackRank),
      displayName: displayName ?? username ?? 'Promoo profile',
      username: username,
      avatarUrl: avatarUrl,
      bio: bio,
      accountType: accountType,
      followersCount: followersCount ?? 0,
      score: score,
      badgeLabel: badgeLabel,
      isVerified: isVerified,
      isFeatured: isFeatured,
    );
  }
}

class LeaderboardProfilesDto {
  const LeaderboardProfilesDto(this.profiles);

  final List<LeaderboardProfileDto> profiles;

  factory LeaderboardProfilesDto.empty() {
    return const LeaderboardProfilesDto([]);
  }

  factory LeaderboardProfilesDto.fromJsonFlexible(Object? value) {
    return LeaderboardProfilesDto(
      _mapsFrom(
        value,
      ).map(LeaderboardProfileDto.fromJson).toList(growable: false),
    );
  }

  List<LeaderboardProfile> toDomain() {
    return [
      for (var i = 0; i < profiles.length; i++)
        if (profiles[i].hasIdentity)
          profiles[i].toDomain(
            fallbackId: 'leaderboard-profile-$i',
            fallbackRank: i + 1,
          ),
    ];
  }
}

List<Map<String, Object?>> _mapsFrom(Object? value) {
  final list = _listFrom(value);
  if (list != null) {
    final maps = <Map<String, Object?>>[];
    for (final item in list) {
      final mapped = _mapFrom(item);
      if (mapped != null) {
        maps.add(mapped);
      }
    }
    return maps;
  }

  final single = _mapFrom(value);
  if (single == null) {
    return const [];
  }
  return [single];
}

List<Object?>? _listFrom(Object? value) {
  if (value is List) {
    return List<Object?>.from(value);
  }

  final map = _mapFrom(value);
  if (map == null) {
    return null;
  }

  for (final key in const [
    'data',
    'items',
    'results',
    'profiles',
    'leaderboard',
    'rankings',
    'records',
  ]) {
    final nested = map[key];
    if (nested is List) {
      return List<Object?>.from(nested);
    }

    final nestedList = _listFrom(nested);
    if (nestedList != null) {
      return nestedList;
    }
  }

  return null;
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

int? _readInt(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
  }
  return null;
}

bool _readBool(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
  }
  return false;
}
