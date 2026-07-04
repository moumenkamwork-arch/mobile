import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';

void main() {
  test('fixture provides more than three top offer slides', () {
    expect(HomeContentDto.fixture().offers.length, greaterThan(3));
  });

  test('fixture provides grouped story items per visible story owner', () {
    final stories = HomeContentDto.fixture().toDomain().stories;

    expect(stories, isNotEmpty);
    expect(stories.first.profileName, 'Maya Studio');
    expect(stories.first.effectiveItems.length, greaterThanOrEqualTo(3));
    expect(
      stories.first.effectiveItems.first.title,
      'Launch day edits are ready for review.',
    );
  });

  test('parses minimal backend success fixture', () {
    final dto = HomeContentDto.fromJsonFlexible({
      'success': true,
      'data': {
        'categories': [
          {'id': 'cat-1', 'name': 'Beauty'},
        ],
        'services': [
          {
            'id': 'service-1',
            'title': 'Event coverage',
            'category': {'name': 'Events'},
          },
        ],
        'featured_profiles': [
          {
            'id': 'feature-1',
            'profile': {
              'id': 'profile-1',
              'full_name': 'Saffron Social Studio',
              'username': 'saffron.social',
              'account_type': 'company',
              'is_verified': true,
            },
          },
        ],
        'promoo_of_the_day': {
          'id': 'offer-1',
          'title': 'Promoo of the day',
          'description': 'A featured partner offer.',
        },
      },
    });

    final content = dto.toDomain();

    expect(content.highlight?.title, 'Promoo of the day');
    expect(content.categories.single.name, 'Beauty');
    expect(content.services.single.categoryName, 'Events');
    expect(content.profiles.single.name, 'Saffron Social Studio');
    expect(content.profiles.single.isVerified, isTrue);
  });

  test('parses wrapped offer detail with nested profile and category', () {
    final dto = HomeContentDetailDto.fromJsonFlexible({
      'success': true,
      'data': {
        'id': 'offer-1',
        'title': 'Cafe opening spotlight',
        'description': 'Discovery placement for a new cafe launch.',
        'offer_price': 1500,
        'media_urls': ['https://example.com/offer.jpg'],
        'tags': ['Cafe', 'Opening'],
        'end_date': '2026-08-30',
        'promo_code': 'PEARLSPOTLIGHT',
        'profile': {
          'id': 'profile-pearl-cafe',
          'full_name': 'Pearl District Cafe',
          'username': 'pearl.district',
          'location': 'Sharjah',
          'is_verified': true,
        },
        'category': {'name_en': 'Restaurants & Cafes'},
      },
    }, fallbackType: HomeContentDetailType.offer);

    final detail = dto.toDomain(fallbackId: 'offer-1', fallbackCurrency: 'AED');

    expect(detail.title, 'Cafe opening spotlight');
    expect(detail.type, HomeContentDetailType.offer);
    expect(detail.price?.label, '1500 AED');
    expect(detail.provider?.displayName, 'Pearl District Cafe');
    expect(detail.provider?.isVerified, isTrue);
    expect(detail.categoryName, 'Restaurants & Cafes');
    expect(detail.location, 'Sharjah');
    expect(detail.tags, contains('Cafe'));
    expect(detail.promoCode, 'PEARLSPOTLIGHT');
    expect(detail.validUntil, '2026-08-30');
    expect(detail.imageUrl, 'https://example.com/offer.jpg');
  });

  test('parses active ad list details', () {
    final details = HomeContentDetailDto.listFromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'ad-1',
          'title': 'Featured campaign spotlight',
          'description': 'Premium discovery placement for active campaigns.',
          'media_url': 'https://example.com/ad.jpg',
          'ad_type': 'banner',
          'profile_id': 'profile-saffron-social',
        },
      ],
    }, fallbackType: HomeContentDetailType.ad);

    final detail = details.single.toDomain(
      fallbackId: 'ad-1',
      fallbackCurrency: 'AED',
    );

    expect(detail.type, HomeContentDetailType.ad);
    expect(detail.title, 'Featured campaign spotlight');
    expect(detail.provider?.id, 'profile-saffron-social');
    expect(detail.badge, 'banner');
  });

  test('parses missing optional sections as empty content', () {
    final dto = HomeContentDto.fromJsonFlexible({
      'success': true,
      'data': <String, Object?>{},
    });

    final content = dto.toDomain();

    expect(content.isEmpty, isTrue);
    expect(content.categories, isEmpty);
    expect(content.services, isEmpty);
    expect(content.offers, isEmpty);
    expect(content.profiles, isEmpty);
    expect(content.stories, isEmpty);
  });
}
