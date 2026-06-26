import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/profile/data/dto/profile_dto.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';

void main() {
  test('parses profile details defensively', () {
    final dto = PromooProfileDto.fromJsonFlexible({
      'success': true,
      'data': {
        'id': 'profile-1',
        'full_name': 'Noura Studio',
        'username': 'noura.studio',
        'bio': 'Premium content studio.',
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
        'categories': {'name_en': 'Marketing'},
      },
    });

    final profile = dto.toDomain(fallbackId: 'fallback');

    expect(profile.id, 'profile-1');
    expect(profile.displayName, 'Noura Studio');
    expect(profile.accountType, ProfileAccountType.company);
    expect(profile.categoryName, 'Marketing');
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
        'displayName': 'Omar Creative',
        'accountType': 'influencer',
        'stats': {'followers': '142900', 'offers': 7},
      },
    });

    final profile = dto.toDomain(fallbackId: 'fallback');

    expect(profile.id, 'profile-2');
    expect(profile.displayName, 'Omar Creative');
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
          'title': 'Content package',
          'description': 'Campaign content.',
          'price': 750,
          'category': {'name_en': 'Marketing'},
          'delivery_days': 5,
          'tags': ['Content'],
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
    expect(packages.single.title, 'Content package');
    expect(packages.single.price?.label, '750 AED');
    expect(packages.single.categoryName, 'Marketing');
    expect(packages.single.deliveryDays, 5);
    expect(packages.single.tags, ['Content']);
  });
}
