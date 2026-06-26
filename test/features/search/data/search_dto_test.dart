import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/search/data/dto/search_dto.dart';
import 'package:promoo_app/features/search/domain/entities/search_result.dart';

void main() {
  test('parses grouped all response with mixed result types', () {
    final dto = SearchResultsDto.fromJsonFlexible({
      'success': true,
      'data': {
        'profiles': [
          {
            'id': 'profile-1',
            'full_name': 'Noura Studio',
            'username': 'noura.studio',
            'account_type': 'company',
            'is_verified': true,
          },
        ],
        'services': [
          {
            'id': 'service-1',
            'title': 'Premium content package',
            'price': 750,
            'currency': 'aed',
            'profile': {'id': 'profile-1', 'full_name': 'Noura Studio'},
          },
        ],
        'offers': [
          {
            'id': 'offer-1',
            'title': 'Launch offer',
            'offer_price': 1200,
            'profile': {'id': 'profile-1', 'full_name': 'Noura Studio'},
          },
        ],
        'ads': [
          {'id': 'ad-1', 'title': 'Featured spotlight'},
        ],
      },
    });

    final page = dto.toDomain(fallbackCurrency: 'AED');

    expect(page.results, hasLength(4));
    expect(page.results[0], isA<SearchProfileResult>());
    expect(page.results[1], isA<SearchServiceResult>());
    expect(page.results[2], isA<SearchOfferResult>());
    expect(page.results[3], isA<SearchAdResult>());
    expect((page.results[1] as SearchServiceResult).price?.label, '750 AED');
    expect((page.results[2] as SearchOfferResult).price?.label, '1200 AED');
  });

  test('parses paginated service list response with meta', () {
    final dto = SearchResultsDto.fromJsonFlexible({
      'success': true,
      'data': [
        {'id': 'service-1', 'title': 'Video package', 'price': '900'},
      ],
      'meta': {'page': 2, 'limit': 10, 'total': 21, 'totalPages': 3},
    }, filter: SearchFilterType.services);

    final page = dto.toDomain(fallbackCurrency: 'AED');

    expect(page.page, 2);
    expect(page.limit, 10);
    expect(page.total, 21);
    expect(page.totalPages, 3);
    expect(page.results.single, isA<SearchServiceResult>());
    expect(
      (page.results.single as SearchServiceResult).price?.label,
      '900 AED',
    );
  });

  test('parses direct profile list with account type', () {
    final dto = SearchResultsDto.fromJsonFlexible([
      {
        'id': 'profile-1',
        'full_name': 'Maya Lens',
        'username': 'maya.lens',
        'account_type': 'influencer',
      },
    ], filter: SearchFilterType.influencers);

    final profile =
        dto.toDomain(fallbackCurrency: 'AED').results.single
            as SearchProfileResult;

    expect(profile.title, 'Maya Lens');
    expect(profile.username, 'maya.lens');
    expect(profile.accountType, 'influencer');
  });
}
