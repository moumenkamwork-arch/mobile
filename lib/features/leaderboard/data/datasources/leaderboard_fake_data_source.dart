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
      id: 'leader-noura',
      rank: 1,
      displayName: 'Noura Studio',
      username: 'noura.studio',
      accountType: 'company',
      followersCount: 185400,
      isVerified: true,
      isFeatured: true,
      badgeLabel: 'Top company',
    ),
    LeaderboardProfileDto(
      id: 'leader-omar',
      rank: 2,
      displayName: 'Omar Creative',
      username: 'omar.creative',
      accountType: 'influencer',
      followersCount: 142900,
      isVerified: true,
      badgeLabel: 'Creator',
    ),
    LeaderboardProfileDto(
      id: 'leader-lens',
      rank: 3,
      displayName: 'Lens Partner',
      username: 'lens.partner',
      accountType: 'service_provider',
      followersCount: 98400,
      badgeLabel: 'Service pro',
    ),
    LeaderboardProfileDto(
      id: 'leader-table',
      rank: 4,
      displayName: 'Table Media',
      username: 'table.media',
      accountType: 'company',
      followersCount: 72100,
    ),
    LeaderboardProfileDto(
      id: 'leader-mira',
      rank: 5,
      displayName: 'Mira Selects',
      username: 'mira.selects',
      accountType: 'influencer',
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
