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
            SearchFilterType.ads => item.type == SearchResultType.ad,
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
    searchText: 'Noura Studio company content marketing dubai',
    json: {
      'id': 'profile-demo',
      'full_name': 'Noura Studio',
      'username': 'noura.studio',
      'bio': 'Premium content studio for launch campaigns.',
      'account_type': 'company',
      'location': 'Dubai',
      'is_verified': true,
      'avatar_url': null,
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.profile,
    accountType: 'influencer',
    searchText: 'Maya Lens influencer lifestyle creator abu dhabi',
    json: {
      'id': 'profile-influencer-1',
      'full_name': 'Maya Lens',
      'username': 'maya.lens',
      'bio': 'Lifestyle creator with premium GCC audience.',
      'account_type': 'influencer',
      'location': 'Abu Dhabi',
      'is_verified': true,
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.service,
    searchText: 'Premium content package service video social media',
    json: {
      'id': 'service-content',
      'title': 'Premium content package',
      'description': 'Short-form video and social assets for campaigns.',
      'price': 750,
      'currency': 'AED',
      'category': {'name_en': 'Marketing'},
      'profile': {
        'id': 'profile-demo',
        'full_name': 'Noura Studio',
        'username': 'noura.studio',
        'is_verified': true,
      },
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.offer,
    searchText: 'Launch offer promotion discount content bundle',
    json: {
      'id': 'offer-1',
      'title': 'Launch campaign offer',
      'description': 'Limited campaign bundle for marketplace launches.',
      'offer_price': 1200,
      'currency': 'AED',
      'is_featured': true,
      'profile': {
        'id': 'profile-demo',
        'full_name': 'Noura Studio',
        'username': 'noura.studio',
        'is_verified': true,
      },
    },
  ),
  _FakeSearchRow(
    type: SearchResultType.ad,
    searchText: 'Featured ad spotlight promotion',
    json: {
      'id': 'ad-1',
      'title': 'Featured marketplace spotlight',
      'description': 'Promoted placement for active campaigns.',
      'profile': {
        'id': 'profile-demo',
        'full_name': 'Noura Studio',
        'username': 'noura.studio',
        'is_verified': true,
      },
    },
  ),
];
