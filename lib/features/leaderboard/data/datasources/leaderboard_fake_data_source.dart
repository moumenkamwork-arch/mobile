import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/leaderboard_profile.dart';
import '../dto/leaderboard_dto.dart';
import 'leaderboard_data_source.dart';

final leaderboardFakeDataSourceProvider = Provider<LeaderboardFakeDataSource>((
  ref,
) {
  return const LeaderboardFakeDataSource();
});

class LeaderboardFakeDataSource implements LeaderboardDataSource {
  const LeaderboardFakeDataSource();

  static const _profiles = [
    LeaderboardProfileDto(
      id: 'profile-saffron-social',
      rank: 1,
      displayName: 'Saffron Social Studio',
      username: 'saffron.social',
      avatarUrl:
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=320&q=80',
      bio:
          'Premium launch campaigns, creator partnerships, and polished marketplace visibility.',
      accountType: 'company',
      followersCount: 185400,
      isVerified: true,
      isFeatured: true,
      badgeLabel: 'Top company',
    ),
    LeaderboardProfileDto(
      id: 'profile-lina-atelier',
      rank: 2,
      displayName: 'Lina Atelier',
      username: 'lina.atelier',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=320&q=80',
      bio:
          'Lifestyle creator for premium hospitality, style, and wellness stories.',
      accountType: 'influencer',
      followersCount: 142900,
      isVerified: true,
      badgeLabel: 'Creator',
    ),
    LeaderboardProfileDto(
      id: 'profile-framehouse',
      rank: 3,
      displayName: 'Framehouse Events',
      username: 'framehouse.events',
      avatarUrl:
          'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&w=320&q=80',
      bio: 'Event photography and launch visuals for premium Promoo campaigns.',
      accountType: 'service_provider',
      followersCount: 98400,
      badgeLabel: 'Service pro',
    ),
    LeaderboardProfileDto(
      id: 'profile-pearl-cafe',
      rank: 4,
      displayName: 'Pearl District Cafe',
      username: 'pearl.district',
      avatarUrl:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=320&q=80',
      bio: 'Neighborhood cafe launches, seasonal menus, and warm discovery.',
      accountType: 'company',
      followersCount: 72100,
    ),
    LeaderboardProfileDto(
      id: 'profile-velvet-beauty',
      rank: 5,
      displayName: 'Velvet Beauty Lounge',
      username: 'velvet.beauty',
      avatarUrl:
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=320&q=80',
      bio: 'Beauty and wellness campaigns with polished self-care visuals.',
      accountType: 'service_provider',
      followersCount: 64750,
    ),
  ];

  @override
  Future<LeaderboardProfilesDto> fetchLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    final profiles = _profiles
        .where((profile) {
          if (type == LeaderboardType.all) {
            return profile.accountType != 'user';
          }
          return profile.accountType == type.apiValue;
        })
        .toList(growable: false);

    return LeaderboardProfilesDto(profiles);
  }
}
