import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/promoo_profile.dart';
import '../dto/profile_dto.dart';
import 'profile_data_source.dart';

final profileFakeDataSourceProvider = Provider<ProfileFakeDataSource>((ref) {
  return ProfileFakeDataSource();
});

class ProfileFakeDataSource implements ProfileDataSource {
  ProfileFakeDataSource();

  /// The signed-in "my profile" fixture, mutable so [updateMyProfile] can
  /// persist edits for the lifetime of this data source instance.
  PromooProfileDto _myProfile = _demoProfile;

  static const demoProfileId = 'profile-saffron-social';

  static const _demoProfile = PromooProfileDto(
    id: demoProfileId,
    displayName: 'Saffron Social Studio',
    username: 'saffron.social',
    bio:
        'Boutique campaign studio for premium launches, creator partnerships, and polished marketplace visibility across the UAE.',
    location: 'Dubai',
    avatarUrl:
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Digital Marketing',
    accountType: 'company',
    stats: ProfileStatsDto(
      followers: 185400,
      following: 124,
      offers: 12,
      services: 4,
      likes: 48600,
      posts: 28,
      views: 312000,
    ),
    mediaUrls: [
      'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=900&q=80',
    ],
    isVerified: true,
    isFeatured: true,
  );

  static const _linaProfile = PromooProfileDto(
    id: 'profile-lina-atelier',
    displayName: 'Lina Atelier',
    username: 'lina.atelier',
    bio:
        'Lifestyle creator sharing refined style, hospitality, and wellness moments for GCC audiences.',
    location: 'Dubai',
    avatarUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Lifestyle',
    accountType: 'influencer',
    stats: ProfileStatsDto(
      followers: 142900,
      following: 92,
      offers: 4,
      likes: 39100,
      posts: 21,
      views: 248000,
    ),
    mediaUrls: [
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=900&q=80',
    ],
    isVerified: true,
    isFeatured: true,
  );

  static const _framehouseProfile = PromooProfileDto(
    id: 'profile-framehouse',
    displayName: 'Framehouse Events',
    username: 'framehouse.events',
    bio:
        'Event photography and product visuals for launches and private brand moments.',
    location: 'Dubai',
    avatarUrl:
        'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Events & Photography',
    accountType: 'service_provider',
    stats: ProfileStatsDto(
      followers: 98400,
      services: 2,
      likes: 21300,
      posts: 14,
      views: 126000,
    ),
    isVerified: true,
  );

  static const _pearlCafeProfile = PromooProfileDto(
    id: 'profile-pearl-cafe',
    displayName: 'Pearl District Cafe',
    username: 'pearl.district',
    bio:
        'Specialty cafe concept focused on refined openings, seasonal menus, and warm neighborhood discovery.',
    location: 'Sharjah',
    avatarUrl:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Restaurants & Cafes',
    accountType: 'company',
    stats: ProfileStatsDto(
      followers: 72100,
      offers: 3,
      services: 1,
      likes: 18400,
      posts: 12,
      views: 97000,
    ),
    isVerified: true,
  );

  static const _velvetBeautyProfile = PromooProfileDto(
    id: 'profile-velvet-beauty',
    displayName: 'Velvet Beauty Lounge',
    username: 'velvet.beauty',
    bio:
        'Beauty and wellness lounge with polished launch offers and premium self-care campaigns.',
    location: 'Abu Dhabi',
    avatarUrl:
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Beauty & Wellness',
    accountType: 'service_provider',
    stats: ProfileStatsDto(
      followers: 64750,
      offers: 2,
      services: 1,
      likes: 16900,
      posts: 10,
      views: 89000,
    ),
    isVerified: true,
  );

  static const _calmFitProfile = PromooProfileDto(
    id: 'profile-calmfit',
    displayName: 'CalmFit Wellness',
    username: 'calmfit.wellness',
    bio:
        'Wellness studio concept for calm fitness, recovery, and mindful lifestyle campaigns.',
    location: 'Abu Dhabi',
    avatarUrl:
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Health & Fitness',
    accountType: 'company',
    stats: ProfileStatsDto(
      followers: 58600,
      offers: 2,
      services: 1,
      likes: 14500,
      posts: 9,
      views: 76000,
    ),
  );

  static const _orchidStyleProfile = PromooProfileDto(
    id: 'profile-orchid-style',
    displayName: 'Orchid Styling Co.',
    username: 'orchid.style',
    bio:
        'Styling partner for seasonal edits, creator shoots, and elevated fashion content.',
    location: 'Dubai',
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Fashion & Styling',
    accountType: 'service_provider',
    stats: ProfileStatsDto(
      followers: 43900,
      services: 1,
      likes: 11800,
      posts: 8,
      views: 54000,
    ),
  );

  static const _vistaHomeProfile = PromooProfileDto(
    id: 'profile-vista-home',
    displayName: 'Vista Home Living',
    username: 'vista.home',
    bio:
        'Home and lifestyle concept for warm interiors, decor storytelling, and product visuals.',
    location: 'Ajman',
    avatarUrl:
        'https://images.unsplash.com/photo-1513161455079-7dc1de15ef3e?auto=format&fit=crop&w=320&q=80',
    coverUrl:
        'https://images.unsplash.com/photo-1513161455079-7dc1de15ef3e?auto=format&fit=crop&w=1200&q=80',
    categoryName: 'Home & Lifestyle',
    accountType: 'company',
    stats: ProfileStatsDto(
      followers: 38600,
      services: 1,
      likes: 9700,
      posts: 7,
      views: 42000,
    ),
  );

  static const _profiles = [
    _demoProfile,
    _linaProfile,
    _framehouseProfile,
    _pearlCafeProfile,
    _velvetBeautyProfile,
    _calmFitProfile,
    _orchidStyleProfile,
    _vistaHomeProfile,
  ];

  static const _packages = [
    ProfilePackageDto(
      id: 'package-influencer-launch',
      profileId: demoProfileId,
      title: 'Boutique launch campaign',
      description:
          'Creator coverage, launch positioning, and premium Promoo visibility for a brand opening.',
      price: 2200,
      currency: 'AED',
      categoryName: 'Influencer Campaigns',
      deliveryDays: 5,
      tags: ['Campaign', 'Reels', 'Stories'],
    ),
    ProfilePackageDto(
      id: 'package-ads-strategy',
      profileId: demoProfileId,
      title: 'Launch ads strategy sprint',
      description:
          'A focused campaign strategy session with creative angles, placement guidance, and launch checklist.',
      price: 2800,
      currency: 'AED',
      categoryName: 'Digital Marketing',
      deliveryDays: 7,
      tags: ['Strategy', 'Launch'],
    ),
    ProfilePackageDto(
      id: 'package-profile-refresh',
      profileId: demoProfileId,
      title: 'Profile refresh content pack',
      description:
          'Polished visuals and short copy for an updated Promoo profile presence.',
      price: 1650,
      currency: 'AED',
      categoryName: 'Content',
      deliveryDays: 4,
      tags: ['Profile', 'Content'],
    ),
  ];

  @override
  Future<PromooProfileDto> fetchProfile(String idOrUsername) async {
    final normalized = idOrUsername.trim().toLowerCase();
    for (final profile in _profiles) {
      if (normalized == profile.id?.toLowerCase() ||
          normalized == profile.username?.toLowerCase()) {
        return profile;
      }
    }

    // Unknown demo id (a follow, seat holder, or leaderboard entry that isn't
    // in the curated list): synthesize a plausible, deterministic profile so
    // every profile tap opens a real-looking page instead of "not found".
    return _syntheticProfile(idOrUsername);
  }

  static PromooProfileDto _syntheticProfile(String idOrUsername) {
    final raw = idOrUsername.trim();
    final slug = raw.toLowerCase().startsWith('profile-')
        ? raw.substring('profile-'.length)
        : raw;
    final words = slug
        .split(RegExp(r'[-_.@]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final displayName = words.isEmpty
        ? 'Promoo Member'
        : words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
    final username = words.isEmpty ? 'promoo.member' : words.join('.');
    final seed = slug.hashCode.abs();

    const covers = [
      'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1200&q=80',
    ];
    const categories = [
      'Influencer Campaigns',
      'Beauty & Wellness',
      'Events & Photography',
      'Restaurants & Cafes',
      'Fashion & Styling',
      'Health & Fitness',
    ];
    const accountTypes = ['influencer', 'company', 'service_provider'];

    final followers = 8000 + (seed % 240) * 520;
    final likes = 1500 + (seed % 180) * 260;
    final posts = 6 + (seed % 40);

    return PromooProfileDto(
      id: raw,
      displayName: displayName,
      username: username,
      bio:
          '$displayName is part of the Promoo marketplace, sharing campaigns '
          'and creator collaborations across the UAE.',
      location: 'United Arab Emirates',
      avatarUrl: 'https://i.pravatar.cc/320?u=$slug',
      coverUrl: covers[seed % covers.length],
      categoryName: categories[seed % categories.length],
      accountType: accountTypes[seed % accountTypes.length],
      stats: ProfileStatsDto(
        followers: followers,
        following: 40 + (seed % 300),
        likes: likes,
        posts: posts,
        views: followers * 2 + (seed % 50) * 900,
      ),
      mediaUrls: [
        for (var i = 0; i < 3; i++)
          'https://picsum.photos/seed/$slug$i/600/600',
      ],
      isVerified: seed % 2 == 0,
    );
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() async {
    return _myProfile;
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) async {
    return ProfilePackagesDto(
      _packages
          .where((package) => package.profileId == profileId)
          .toList(growable: false),
    );
  }

  @override
  Future<PromooProfileDto> updateMyProfile(ProfileUpdateDraft draft) async {
    _myProfile = PromooProfileDto(
      id: _myProfile.id,
      displayName: draft.displayName ?? _myProfile.displayName,
      username: draft.username ?? _myProfile.username,
      bio: draft.bio ?? _myProfile.bio,
      location: draft.location ?? _myProfile.location,
      website: draft.website ?? _myProfile.website,
      avatarUrl: _myProfile.avatarUrl,
      coverUrl: _myProfile.coverUrl,
      categoryName: _myProfile.categoryName,
      accountType: _myProfile.accountType,
      stats: _myProfile.stats,
      socialLinks: _myProfile.socialLinks,
      mediaUrls: _myProfile.mediaUrls,
      isVerified: _myProfile.isVerified,
      isFeatured: _myProfile.isFeatured,
    );
    return _myProfile;
  }

  final Set<String> _following = {};

  @override
  Future<bool> fetchFollowStatus(String profileId) async =>
      _following.contains(profileId);

  @override
  Future<void> followProfile(String profileId) async {
    _following.add(profileId);
  }

  @override
  Future<void> unfollowProfile(String profileId) async {
    _following.remove(profileId);
  }
}
