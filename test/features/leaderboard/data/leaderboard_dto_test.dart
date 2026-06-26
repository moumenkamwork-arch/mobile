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
          'full_name': 'Noura Studio',
          'username': 'noura.studio',
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
    expect(profiles.single.displayName, 'Noura Studio');
    expect(profiles.single.username, 'noura.studio');
    expect(profiles.single.accountTypeLabel, 'Company');
    expect(profiles.single.followersCount, 185400);
    expect(profiles.single.followersLabel, '185.4K followers');
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
              'displayName': 'Omar Creative',
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
    expect(profiles.single.displayName, 'Omar Creative');
    expect(profiles.single.followersCount, 142900);
    expect(profiles.single.accountTypeLabel, 'Influencer');
  });
}
