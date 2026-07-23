import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/search_result.dart';
import '../dto/search_dto.dart';
import 'search_data_source.dart';

final searchFakeDataSourceProvider = Provider<SearchFakeDataSource>((ref) {
  return const SearchFakeDataSource();
});

class SearchFakeDataSource implements SearchDataSource {
  const SearchFakeDataSource();

  @override
  Future<SearchResultsDto> search({
    required String query,
    required SearchFilterType filter,
    int page = 1,
    int limit = 20,
  }) async {
    final normalized = query.trim().toLowerCase();
    final filtered = _fakeResults
        .where((item) {
          final matchesQuery =
              normalized.isEmpty ||
              item.searchText.toLowerCase().contains(normalized);
          final matchesType = switch (filter) {
            SearchFilterType.all => true,
            SearchFilterType.profiles => item.type == SearchResultType.profile,
            SearchFilterType.influencers =>
              item.type == SearchResultType.profile &&
                  item.accountType == 'influencer',
            SearchFilterType.services => item.type == SearchResultType.service,
            SearchFilterType.offers => item.type == SearchResultType.offer,
          };
          return matchesQuery && matchesType;
        })
        .toList(growable: false);

    final start = (page - 1) * limit;
    final end = start + limit;
    final pageItems = start >= filtered.length
        ? const <_FakeSearchRow>[]
        : filtered.sublist(
            start,
            end > filtered.length ? filtered.length : end,
          );

    return SearchResultsDto(
      results: [
        for (final item in pageItems)
          SearchResultDto.fromJson(item.json, fallbackType: item.type),
      ],
      page: page,
      limit: limit,
      total: filtered.length,
      totalPages: (filtered.length / limit).ceil(),
    );
  }
}

class _FakeSearchRow {
  const _FakeSearchRow({
    required this.type,
    required this.searchText,
    required this.json,
    this.accountType,
  });

  final SearchResultType type;
  final String searchText;
  final Map<String, Object?> json;
  final String? accountType;
}

const _fakeResults = [
  _FakeSearchRow(
    type: SearchResultType.profile,
    accountType: 'company',
    searchText: 'Saffron Social Studio company campaign marketing dubai',
    json: {
      'id': 'profile-saffron-social',
      'full_name': 'Saffron Social Studio',
      'username': 'saffron.social',
      'bio': 'Boutique campaign studio for premium launch visibility.',
      'account_type': 'company',
      'location': 'Dubai',
      'is_verified': true,
      'avatar_url': null,
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.profile,
    accountType: 'influencer',
    searchText: 'Lina Atelier influencer lifestyle style dubai creator',
    json: {
      'id': 'profile-lina-atelier',
      'full_name': 'Lina Atelier',
      'username': 'lina.atelier',
      'bio': 'Lifestyle creator with a refined GCC audience.',
      'account_type': 'influencer',
      'location': 'Dubai',
      'is_verified': true,
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.service,
    searchText:
        'Boutique influencer launch package service campaign reels stories',
    json: {
      'id': 'service-influencer-launch',
      'title': 'Boutique influencer launch package',
      'description': 'Creator coverage and campaign guidance for launches.',
      'price': 2200,
      'currency': 'AED',
      'category': {'name_en': 'Influencer Campaigns'},
      'profile': {
        'id': 'profile-saffron-social',
        'full_name': 'Saffron Social Studio',
        'username': 'saffron.social',
        'is_verified': true,
      },
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.service,
    searchText: 'Product photography session service framehouse events dubai',
    json: {
      'id': 'service-product-photography',
      'title': 'Product photography session',
      'description': 'Editorial visuals for products, launches, and profiles.',
      'price': 1450,
      'currency': 'AED',
      'category': {'name_en': 'Events & Photography'},
      'profile': {
        'id': 'profile-framehouse',
        'full_name': 'Framehouse Events',
        'username': 'framehouse.events',
        'is_verified': true,
      },
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.offer,
    searchText: 'Cafe opening spotlight offer restaurants cafes sharjah',
    json: {
      'id': 'offer-1',
      'title': 'Cafe opening spotlight',
      'description': 'Discovery placement for a new cafe launch.',
      'offer_price': 1500,
      'currency': 'AED',
      'is_featured': true,
      'profile': {
        'id': 'profile-pearl-cafe',
        'full_name': 'Pearl District Cafe',
        'username': 'pearl.district',
        'is_verified': true,
      },
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.offer,
    searchText: 'Wellness week visibility offer health fitness abu dhabi',
    json: {
      'id': 'offer-2',
      'title': 'Wellness week visibility',
      'description': 'Premium awareness push for wellness providers.',
      'offer_price': 1350,
      'currency': 'AED',
      'is_featured': false,
      'profile': {
        'id': 'profile-calmfit',
        'full_name': 'CalmFit Wellness',
        'username': 'calmfit.wellness',
      },
    },
  ),
];
