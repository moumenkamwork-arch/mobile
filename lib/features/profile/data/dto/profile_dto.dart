import '../../domain/entities/promoo_profile.dart';

class PromooProfileDto {
  const PromooProfileDto({
    this.id,
    this.displayName,
    this.username,
    this.bio,
    this.location,
    this.website,
    this.avatarUrl,
    this.coverUrl,
    this.categoryName,
    this.accountType,
    this.stats = const ProfileStatsDto(),
    this.socialLinks = const {},
    this.mediaUrls = const [],
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String? id;
  final String? displayName;
  final String? username;
  final String? bio;
  final String? location;
  final String? website;
  final String? avatarUrl;
  final String? coverUrl;
  final String? categoryName;
  final String? accountType;
  final ProfileStatsDto stats;
  final Map<String, String> socialLinks;
  final List<String> mediaUrls;
  final bool isVerified;
  final bool isFeatured;

  factory PromooProfileDto.fromJsonFlexible(Object? value) {
    final map = _firstMapFrom(value);
    if (map == null) {
      return const PromooProfileDto();
    }

    final category = _mapFrom(map['categories']) ?? _mapFrom(map['category']);

    return PromooProfileDto(
      id: _readString(map, const ['id', 'profile_id', 'profileId']),
      displayName: _readString(map, const [
        'full_name',
        'fullName',
        'display_name',
        'displayName',
        'name',
        'username',
      ]),
      username: _readString(map, const ['username']),
      bio: _readString(map, const ['bio', 'about', 'description']),
      location: _readString(map, const ['location', 'city']),
      website: _readString(map, const ['website', 'website_url', 'websiteUrl']),
      avatarUrl: _readString(map, const ['avatar_url', 'avatarUrl', 'avatar']),
      coverUrl: _readString(map, const ['cover_url', 'coverUrl', 'cover']),
      categoryName:
          _readString(map, const ['category_name', 'categoryName']) ??
          _readString(category ?? const {}, const [
            'name',
            'name_en',
            'name_ar',
          ]),
      accountType: _readString(map, const ['account_type', 'accountType']),
      stats: ProfileStatsDto.fromJson(map),
      socialLinks: _readStringMap(map['social_links'] ?? map['socialLinks']),
      mediaUrls: _readStringList(map, const [
        'media',
        'posts',
        'media_urls',
        'mediaUrls',
        'media_url',
        'mediaUrl',
        'image_url',
        'imageUrl',
        'gallery',
        'images',
      ]),
      isVerified: _readBool(map, const ['is_verified', 'isVerified']),
      isFeatured: _readBool(map, const ['is_featured', 'isFeatured']),
    );
  }

  bool get hasIdentity => id != null || displayName != null || username != null;

  PromooProfile toDomain({required String fallbackId}) {
    return PromooProfile(
      id: id ?? fallbackId,
      displayName: displayName ?? username ?? 'Promoo profile',
      username: username,
      bio: bio,
      location: location,
      website: website,
      avatarUrl: avatarUrl,
      coverUrl: coverUrl,
      categoryName: categoryName,
      accountType: ProfileAccountTypeValue.fromValue(accountType),
      stats: stats.toDomain(),
      socialLinks: socialLinks,
      mediaUrls: mediaUrls,
      isVerified: isVerified,
      isFeatured: isFeatured,
    );
  }
}

class ProfileStatsDto {
  const ProfileStatsDto({
    this.followers,
    this.following,
    this.offers,
    this.services,
    this.likes,
    this.posts,
    this.views,
  });

  final int? followers;
  final int? following;
  final int? offers;
  final int? services;
  final int? likes;
  final int? posts;
  final int? views;

  factory ProfileStatsDto.fromJson(Map<String, Object?> map) {
    final nested = _mapFrom(map['stats']) ?? const {};
    return ProfileStatsDto(
      followers:
          _readInt(map, const ['followers_count', 'followersCount']) ??
          _readInt(nested, const ['followers', 'followers_count']),
      following:
          _readInt(map, const ['following_count', 'followingCount']) ??
          _readInt(nested, const ['following', 'following_count']),
      offers:
          _readInt(map, const ['offers_count', 'offersCount']) ??
          _readInt(nested, const ['offers', 'offers_count']),
      services:
          _readInt(map, const ['services_count', 'servicesCount']) ??
          _readInt(nested, const ['services', 'services_count']),
      likes:
          _readInt(map, const ['likes_count', 'likesCount']) ??
          _readInt(nested, const ['likes', 'likes_count']),
      posts:
          _readInt(map, const ['posts_count', 'postsCount']) ??
          _readInt(nested, const ['posts', 'posts_count']),
      views:
          _readInt(map, const ['views_count', 'viewsCount']) ??
          _readInt(nested, const ['views', 'views_count']),
    );
  }

  ProfileStats toDomain() {
    return ProfileStats(
      followers: followers ?? 0,
      following: following ?? 0,
      offers: offers ?? 0,
      services: services ?? 0,
      likes: likes ?? 0,
      posts: posts ?? offers ?? services ?? 0,
      views: views ?? 0,
    );
  }
}

class ProfilePackageDto {
  const ProfilePackageDto({
    this.id,
    this.profileId,
    this.title,
    this.description,
    this.price,
    this.currency,
    this.categoryName,
    this.imageUrls = const [],
    this.deliveryDays,
    this.tags = const [],
  });

  final String? id;
  final String? profileId;
  final String? title;
  final String? description;
  final num? price;
  final String? currency;
  final String? categoryName;
  final List<String> imageUrls;
  final int? deliveryDays;
  final List<String> tags;

  factory ProfilePackageDto.fromJson(Map<String, Object?> json) {
    final profile = _mapFrom(json['profile']);
    final category = _mapFrom(json['category']);

    return ProfilePackageDto(
      id: _readString(json, const ['id', 'service_id', 'serviceId']),
      profileId:
          _readString(json, const ['profile_id', 'profileId']) ??
          _readString(profile ?? const {}, const ['id']),
      title: _readString(json, const ['title', 'name', 'service_name']),
      description: _readString(json, const [
        'description',
        'subtitle',
        'short_description',
        'summary',
      ]),
      price: _readNum(json, const ['price', 'amount']),
      currency: _readString(json, const ['currency']),
      categoryName:
          _readString(json, const ['category_name', 'categoryName']) ??
          _readString(category ?? const {}, const [
            'name',
            'name_en',
            'name_ar',
          ]),
      imageUrls: _readStringList(json, const [
        'media_urls',
        'mediaUrls',
        'image_urls',
        'imageUrls',
      ]),
      deliveryDays: _readInt(json, const ['delivery_days', 'deliveryDays']),
      tags: _readStringList(json, const ['tags']),
    );
  }

  bool get hasContent => id != null || title != null;

  ProfilePackage toDomain({
    required String fallbackId,
    required String fallbackCurrency,
  }) {
    return ProfilePackage(
      id: id ?? fallbackId,
      title: title ?? 'Package',
      description: description,
      price: price == null
          ? null
          : ProfilePackagePrice(
              amount: price!,
              currency: _cleanCurrency(currency) ?? fallbackCurrency,
            ),
      categoryName: categoryName,
      imageUrls: imageUrls,
      deliveryDays: deliveryDays,
      tags: tags,
    );
  }
}

class ProfilePackagesDto {
  const ProfilePackagesDto(this.packages);

  final List<ProfilePackageDto> packages;

  factory ProfilePackagesDto.empty() {
    return const ProfilePackagesDto([]);
  }

  factory ProfilePackagesDto.fromJsonFlexible(Object? value) {
    return ProfilePackagesDto(
      _mapsFrom(value).map(ProfilePackageDto.fromJson).toList(growable: false),
    );
  }

  List<ProfilePackage> toDomain({
    required String fallbackCurrency,
    String? profileId,
  }) {
    final filtered = profileId == null
        ? packages
        : packages.where((item) => item.profileId == profileId);

    return [
      for (var i = 0; i < filtered.length; i++)
        if (filtered.elementAt(i).hasContent)
          filtered
              .elementAt(i)
              .toDomain(
                fallbackId: 'profile-package-$i',
                fallbackCurrency: fallbackCurrency,
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
    'services',
    'packages',
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

Map<String, Object?>? _firstMapFrom(Object? value) {
  final direct = _mapFrom(value);
  if (direct == null) {
    return null;
  }
  for (final key in const ['data', 'profile', 'account', 'user']) {
    final nested = _mapFrom(direct[key]);
    if (nested != null) {
      return nested;
    }
  }
  return direct;
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

num? _readNum(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
  }
  return null;
}

int? _readInt(Map<String, Object?> map, List<String> keys) {
  final value = _readNum(map, keys);
  return value?.toInt();
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

List<String> _readStringList(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }
    if (value is List) {
      return _readStringsFromList(value);
    }
  }
  return const [];
}

List<String> _readStringsFromList(List<Object?> value) {
  final strings = <String>[];
  for (final item in value) {
    if (item is String && item.trim().isNotEmpty) {
      strings.add(item.trim());
      continue;
    }

    final map = _mapFrom(item);
    if (map == null) {
      continue;
    }

    final mediaUrl = _readString(map, const [
      'url',
      'media_url',
      'mediaUrl',
      'image_url',
      'imageUrl',
      'thumbnail_url',
      'thumbnailUrl',
      'file_url',
      'fileUrl',
      'public_url',
      'publicUrl',
    ]);
    if (mediaUrl != null) {
      strings.add(mediaUrl);
    }
  }
  return strings;
}

Map<String, String> _readStringMap(Object? value) {
  final map = _mapFrom(value);
  if (map == null) {
    return const {};
  }
  return {
    for (final entry in map.entries)
      if (entry.value is String && (entry.value! as String).trim().isNotEmpty)
        entry.key: (entry.value! as String).trim(),
  };
}

String? _cleanCurrency(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value.trim().toUpperCase();
}
