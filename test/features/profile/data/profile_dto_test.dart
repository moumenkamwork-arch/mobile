import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/profile/data/dto/profile_dto.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';

void main() {
  test('parses profile details defensively', () {
    final dto = PromooProfileDto.fromJsonFlexible({
      'success': true,
      'data': {
        'id': 'profile-1',
        'full_name': 'Saffron Social Studio',
        'username': 'saffron.social',
        'bio': 'Boutique campaign studio.',
        'location': 'Dubai',
        'website': 'https://example.com',
        'avatar_url': 'https://example.com/avatar.png',
        'cover_url': 'https://example.com/cover.png',
        'account_type': 'company',
        'followers_count': 185400,
        'following_count': 124,
        'services_count': 3,
        'media': [
          {'media_url': 'https://example.com/post-1.jpg'},
          {'url': 'https://example.com/post-2.mp4'},
        ],
        'is_verified': true,
        'categories': {'name_en': 'Digital Marketing'},
      },
    });

    final profile = dto.toDomain(fallbackId: 'fallback');

    expect(profile.id, 'profile-1');
    expect(profile.displayName, 'Saffron Social Studio');
    expect(profile.accountType, ProfileAccountType.company);
    expect(profile.categoryName, 'Digital Marketing');
    expect(profile.stats.followers, 185400);
    expect(profile.stats.services, 3);
    expect(profile.mediaUrls, [
      'https://example.com/post-1.jpg',
      'https://example.com/post-2.mp4',
    ]);
    expect(profile.isVerified, isTrue);
  });

  test('parses nested profile variant with stats object', () {
    final dto = PromooProfileDto.fromJsonFlexible({
      'profile': {
        'profileId': 'profile-2',
        'displayName': 'Lina Atelier',
        'accountType': 'influencer',
        'stats': {'followers': '142900', 'offers': 7},
      },
    });

    final profile = dto.toDomain(fallbackId: 'fallback');

    expect(profile.id, 'profile-2');
    expect(profile.displayName, 'Lina Atelier');
    expect(profile.accountType, ProfileAccountType.influencer);
    expect(profile.stats.followers, 142900);
    expect(profile.stats.offers, 7);
  });

  test('parses profile packages from service rows and filters by profile', () {
    final dto = ProfilePackagesDto.fromJsonFlexible({
      'data': [
        {
          'id': 'service-1',
          'profile_id': 'profile-1',
          'title': 'Boutique launch campaign',
          'description': 'Creator coverage and launch positioning.',
          'price': 2200,
          'category': {'name_en': 'Influencer Campaigns'},
          'delivery_days': 5,
          'tags': ['Campaign'],
        },
        {
          'id': 'service-2',
          'profile_id': 'profile-2',
          'title': 'Other package',
          'price': 900,
          'currency': 'usd',
        },
      ],
    });

    final packages = dto.toDomain(
      fallbackCurrency: 'AED',
      profileId: 'profile-1',
    );

    expect(packages.single.id, 'service-1');
    expect(packages.single.title, 'Boutique launch campaign');
    expect(packages.single.price?.label, '2200 AED');
    expect(packages.single.categoryName, 'Influencer Campaigns');
    expect(packages.single.deliveryDays, 5);
    expect(packages.single.tags, ['Campaign']);
  });
}
