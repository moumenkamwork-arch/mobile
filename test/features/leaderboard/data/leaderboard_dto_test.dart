import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/leaderboard/data/dto/leaderboard_dto.dart';

void main() {
  test('parses leaderboard paginated fixture defensively', () {
    final dto = LeaderboardProfilesDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'rank': 1,
          'id': 'profile-1',
          'full_name': 'Saffron Social Studio',
          'username': 'saffron.social',
          'avatar_url': 'https://example.com/avatar.png',
          'bio': 'Campaign studio',
          'account_type': 'company',
          'followers_count': 185400,
          'is_verified': true,
          'is_featured': true,
        },
      ],
      'meta': {'page': 1, 'limit': 20, 'total': 1},
    });

    final profiles = dto.toDomain();

    expect(profiles.single.id, 'profile-1');
    expect(profiles.single.rank.value, 1);
    expect(profiles.single.displayName, 'Saffron Social Studio');
    expect(profiles.single.username, 'saffron.social');
    expect(profiles.single.accountType, 'company');
    expect(profiles.single.followersCount, 185400);
    expect(profiles.single.compactFollowersCount, '185.4K');
    expect(profiles.single.isVerified, isTrue);
    expect(profiles.single.isFeatured, isTrue);
  });

  test('parses nested profile variants and falls back to list rank', () {
    final dto = LeaderboardProfilesDto.fromJsonFlexible({
      'data': {
        'items': [
          {
            'profile': {
              'profile_id': 'profile-2',
              'displayName': 'Lina Atelier',
              'followersCount': '142900',
              'accountType': 'influencer',
            },
          },
        ],
      },
    });

    final profiles = dto.toDomain();

    expect(profiles.single.id, 'profile-2');
    expect(profiles.single.rank.value, 1);
    expect(profiles.single.displayName, 'Lina Atelier');
    expect(profiles.single.followersCount, 142900);
    expect(profiles.single.accountType, 'influencer');
  });
}
