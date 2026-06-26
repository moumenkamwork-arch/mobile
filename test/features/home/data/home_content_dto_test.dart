import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';

void main() {
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
              'full_name': 'Noura Studio',
              'username': 'noura',
              'account_type': 'influencer',
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
    expect(content.profiles.single.name, 'Noura Studio');
    expect(content.profiles.single.isVerified, isTrue);
  });

  test('parses wrapped offer detail with nested profile and category', () {
    final dto = HomeContentDetailDto.fromJsonFlexible({
      'success': true,
      'data': {
        'id': 'offer-1',
        'title': 'Launch week promotion',
        'description': 'A highlighted offer for launch partners.',
        'offer_price': 1200,
        'media_urls': ['https://example.com/offer.jpg'],
        'tags': ['Launch', 'Social'],
        'end_date': '2026-08-30',
        'promo_code': 'PROMOO-LAUNCH',
        'profile': {
          'id': 'profile-demo',
          'full_name': 'Noura Studio',
          'username': 'noura.studio',
          'location': 'Dubai',
          'is_verified': true,
        },
        'category': {'name_en': 'Marketing'},
      },
    }, fallbackType: HomeContentDetailType.offer);

    final detail = dto.toDomain(fallbackId: 'offer-1', fallbackCurrency: 'AED');

    expect(detail.title, 'Launch week promotion');
    expect(detail.type, HomeContentDetailType.offer);
    expect(detail.price?.label, '1200 AED');
    expect(detail.provider?.displayName, 'Noura Studio');
    expect(detail.provider?.isVerified, isTrue);
    expect(detail.categoryName, 'Marketing');
    expect(detail.location, 'Dubai');
    expect(detail.tags, contains('Launch'));
    expect(detail.promoCode, 'PROMOO-LAUNCH');
    expect(detail.validUntil, '2026-08-30');
    expect(detail.imageUrl, 'https://example.com/offer.jpg');
  });

  test('parses active ad list details', () {
    final details = HomeContentDetailDto.listFromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'ad-1',
          'title': 'Featured marketplace spotlight',
          'description': 'Promoted placement for active campaigns.',
          'media_url': 'https://example.com/ad.jpg',
          'ad_type': 'banner',
          'profile_id': 'profile-demo',
        },
      ],
    }, fallbackType: HomeContentDetailType.ad);

    final detail = details.single.toDomain(
      fallbackId: 'ad-1',
      fallbackCurrency: 'AED',
    );

    expect(detail.type, HomeContentDetailType.ad);
    expect(detail.title, 'Featured marketplace spotlight');
    expect(detail.provider?.id, 'profile-demo');
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
