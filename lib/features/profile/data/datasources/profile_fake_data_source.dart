import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/profile_dto.dart';
import 'profile_data_source.dart';

final profileFakeDataSourceProvider = Provider<ProfileFakeDataSource>((ref) {
  return const ProfileFakeDataSource();
});

class ProfileFakeDataSource implements ProfileDataSource {
  const ProfileFakeDataSource();

  static const demoProfileId = 'profile-demo';

  static const _demoProfile = PromooProfileDto(
    id: demoProfileId,
    displayName: 'Noura Studio',
    username: 'noura.studio',
    bio:
        'Premium content studio for campaign launches, creator activations, and polished social packages.',
    location: 'Dubai',
    website: 'https://promoo.example/noura-studio',
    categoryName: 'Marketing',
    accountType: 'company',
    stats: ProfileStatsDto(
      followers: 185400,
      following: 124,
      offers: 12,
      services: 3,
    ),
    socialLinks: {'instagram': 'https://instagram.com/noura.studio'},
    mediaUrls: [
      'mock://noura-studio/launch-reel',
      'mock://noura-studio/venue-shoot',
      'mock://noura-studio/product-story',
      'mock://noura-studio/campaign-post',
      'mock://noura-studio/event-recap',
      'mock://noura-studio/creator-spotlight',
    ],
    isVerified: true,
    isFeatured: true,
  );

  static const _lensProfile = PromooProfileDto(
    id: 'provider-lens',
    displayName: 'Lens Partner',
    username: 'lens.partner',
    bio: 'Photo and video partner for launches, events, and premium coverage.',
    location: 'Dubai',
    categoryName: 'Events',
    accountType: 'company',
    stats: ProfileStatsDto(followers: 42800, services: 1),
    isVerified: true,
  );

  static const _tableProfile = PromooProfileDto(
    id: 'provider-table',
    displayName: 'Table Media',
    username: 'table.media',
    bio: 'Food and restaurant media team for polished launch reels.',
    location: 'Abu Dhabi',
    categoryName: 'Food',
    accountType: 'company',
    stats: ProfileStatsDto(followers: 36100, services: 1),
    isVerified: true,
  );

  static const _packages = [
    ProfilePackageDto(
      id: 'package-content',
      profileId: demoProfileId,
      title: 'Premium content package',
      description: 'Short-form social content for marketplace campaigns.',
      price: 750,
      currency: 'AED',
      categoryName: 'Marketing',
      deliveryDays: 5,
      tags: ['Content', 'Video'],
    ),
    ProfilePackageDto(
      id: 'package-launch',
      profileId: demoProfileId,
      title: 'Launch campaign kit',
      description: 'A compact campaign package for product or venue launches.',
      price: 1800,
      currency: 'AED',
      categoryName: 'Campaigns',
      deliveryDays: 7,
      tags: ['Launch', 'Social'],
    ),
    ProfilePackageDto(
      id: 'package-reel',
      profileId: demoProfileId,
      title: 'Hero reel edit',
      description: 'A polished reel optimized for high-impact profile content.',
      price: 950,
      currency: 'AED',
      categoryName: 'Video',
      deliveryDays: 3,
      tags: ['Reels'],
    ),
  ];

  Future<PromooProfileDto> fetchDemoProfile() async {
    return _demoProfile;
  }

  @override
  Future<PromooProfileDto> fetchProfile(String idOrUsername) async {
    if (idOrUsername == demoProfileId ||
        idOrUsername == _demoProfile.username ||
        idOrUsername == 'demo') {
      return _demoProfile;
    }
    if (idOrUsername == _lensProfile.id ||
        idOrUsername == _lensProfile.username) {
      return _lensProfile;
    }
    if (idOrUsername == _tableProfile.id ||
        idOrUsername == _tableProfile.username) {
      return _tableProfile;
    }
    throw const FormatException('Profile not found.');
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() async {
    return _demoProfile;
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) async {
    return ProfilePackagesDto(
      _packages
          .where((package) => package.profileId == profileId)
          .toList(growable: false),
    );
  }
}
