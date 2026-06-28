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
            'full_name': 'Saffron Social Studio',
            'username': 'saffron.social',
            'account_type': 'company',
            'is_verified': true,
          },
        ],
        'services': [
          {
            'id': 'service-1',
            'title': 'Boutique influencer launch package',
            'price': 2200,
            'currency': 'aed',
            'profile': {
              'id': 'profile-1',
              'full_name': 'Saffron Social Studio',
            },
          },
        ],
        'offers': [
          {
            'id': 'offer-1',
            'title': 'Cafe opening spotlight',
            'offer_price': 1500,
            'profile': {'id': 'profile-2', 'full_name': 'Pearl District Cafe'},
          },
        ],
        'ads': [
          {'id': 'ad-1', 'title': 'Featured campaign spotlight'},
        ],
      },
    });

    final page = dto.toDomain(fallbackCurrency: 'AED');

    expect(page.results, hasLength(4));
    expect(page.results[0], isA<SearchProfileResult>());
    expect(page.results[1], isA<SearchServiceResult>());
    expect(page.results[2], isA<SearchOfferResult>());
    expect(page.results[3], isA<SearchAdResult>());
    expect((page.results[1] as SearchServiceResult).price?.label, '2200 AED');
    expect((page.results[2] as SearchOfferResult).price?.label, '1500 AED');
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
        'full_name': 'Lina Atelier',
        'username': 'lina.atelier',
        'account_type': 'influencer',
      },
    ], filter: SearchFilterType.influencers);

    final profile =
        dto.toDomain(fallbackCurrency: 'AED').results.single
            as SearchProfileResult;

    expect(profile.title, 'Lina Atelier');
    expect(profile.username, 'lina.atelier');
    expect(profile.accountType, 'influencer');
  });
}
