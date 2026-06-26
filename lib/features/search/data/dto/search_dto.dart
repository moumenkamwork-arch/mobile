import '../../domain/entities/search_result.dart';

class SearchResultsDto {
  const SearchResultsDto({
    required this.results,
    this.page = 1,
    this.limit = 20,
    this.total,
    this.totalPages,
  });

  final List<SearchResultDto> results;
  final int page;
  final int limit;
  final int? total;
  final int? totalPages;

  factory SearchResultsDto.empty() {
    return const SearchResultsDto(results: []);
  }

  factory SearchResultsDto.fromJsonFlexible(
    Object? value, {
    SearchFilterType filter = SearchFilterType.all,
  }) {
    return _fromData(value, filter: filter, meta: _readMeta(value));
  }

  SearchResultsDto withMeta(Map<String, Object?>? meta) {
    if (meta == null) {
      return this;
    }
    return SearchResultsDto(
      results: results,
      page: _readInt(meta, const ['page']) ?? page,
      limit: _readInt(meta, const ['limit']) ?? limit,
      total: _readInt(meta, const ['total']) ?? total,
      totalPages:
          _readInt(meta, const ['totalPages', 'total_pages']) ?? totalPages,
    );
  }

  SearchResultsPage toDomain({required String fallbackCurrency}) {
    final mapped = <SearchResult>[];
    for (var i = 0; i < results.length; i++) {
      final result = results[i].toDomain(
        fallbackId: 'search-result-$i',
        fallbackCurrency: fallbackCurrency,
      );
      if (result != null) {
        mapped.add(result);
      }
    }

    return SearchResultsPage(
      results: mapped,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
    );
  }

  static SearchResultsDto _fromData(
    Object? value, {
    required SearchFilterType filter,
    Map<String, Object?>? meta,
  }) {
    final map = _mapFrom(value);
    if (map != null) {
      final data = map['data'];
      final hasEnvelope =
          map.containsKey('success') ||
          map.containsKey('message') ||
          map.containsKey('meta');
      if (hasEnvelope && data != null) {
        return _fromData(data, filter: filter, meta: _readMeta(map) ?? meta);
      }

      final directData = map['data'];
      if (directData is List) {
        return SearchResultsDto(
          results: _parseList(directData, filter.fallbackResultType),
          page:
              _readInt(map, const ['page']) ??
              _readInt(meta, const ['page']) ??
              1,
          limit:
              _readInt(map, const ['limit']) ??
              _readInt(meta, const ['limit']) ??
              20,
          total:
              _readInt(map, const ['total']) ?? _readInt(meta, const ['total']),
          totalPages:
              _readInt(map, const ['totalPages', 'total_pages']) ??
              _readInt(meta, const ['totalPages', 'total_pages']),
        );
      }

      final grouped = _parseGroupedResults(map);
      if (grouped.isNotEmpty) {
        return SearchResultsDto(
          results: grouped,
          page: _readInt(meta, const ['page']) ?? 1,
          limit: _readInt(meta, const ['limit']) ?? 20,
          total: _readInt(meta, const ['total']),
          totalPages: _readInt(meta, const ['totalPages', 'total_pages']),
        );
      }

      final nestedList = _firstListFrom(map, const [
        'results',
        'items',
        'records',
      ]);
      if (nestedList != null) {
        return SearchResultsDto(
          results: _parseList(nestedList, filter.fallbackResultType),
          page: _readInt(meta, const ['page']) ?? 1,
          limit: _readInt(meta, const ['limit']) ?? 20,
          total: _readInt(meta, const ['total']),
          totalPages: _readInt(meta, const ['totalPages', 'total_pages']),
        );
      }
    }

    if (value is List) {
      return SearchResultsDto(
        results: _parseList(value, filter.fallbackResultType),
        page: _readInt(meta, const ['page']) ?? 1,
        limit: _readInt(meta, const ['limit']) ?? 20,
        total: _readInt(meta, const ['total']),
        totalPages: _readInt(meta, const ['totalPages', 'total_pages']),
      );
    }

    final single = _mapFrom(value);
    if (single == null) {
      return SearchResultsDto.empty();
    }

    return SearchResultsDto(
      results: [
        SearchResultDto.fromJson(
          single,
          fallbackType: filter.fallbackResultType,
        ),
      ],
      page: _readInt(meta, const ['page']) ?? 1,
      limit: _readInt(meta, const ['limit']) ?? 20,
      total: _readInt(meta, const ['total']),
      totalPages: _readInt(meta, const ['totalPages', 'total_pages']),
    );
  }

  static List<SearchResultDto> _parseGroupedResults(Map<String, Object?> map) {
    final results = <SearchResultDto>[];
    results.addAll(_parseList(map['profiles'], SearchResultType.profile));
    results.addAll(_parseList(map['services'], SearchResultType.service));
    results.addAll(_parseList(map['offers'], SearchResultType.offer));
    results.addAll(_parseList(map['ads'], SearchResultType.ad));
    return results;
  }

  static List<SearchResultDto> _parseList(
    Object? value,
    SearchResultType fallbackType,
  ) {
    if (value is! List) {
      return const [];
    }

    final results = <SearchResultDto>[];
    for (final item in value) {
      final map = _mapFrom(item);
      if (map != null) {
        results.add(SearchResultDto.fromJson(map, fallbackType: fallbackType));
      }
    }
    return results;
  }
}

class SearchResultDto {
  const SearchResultDto({
    this.id,
    required this.type,
    this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.username,
    this.accountType,
    this.location,
    this.isVerified = false,
    this.isFeatured = false,
    this.price,
    this.currency,
    this.categoryName,
    this.provider,
  });

  final String? id;
  final SearchResultType type;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final String? username;
  final String? accountType;
  final String? location;
  final bool isVerified;
  final bool isFeatured;
  final num? price;
  final String? currency;
  final String? categoryName;
  final SearchResultProviderDto? provider;

  factory SearchResultDto.fromJson(
    Map<String, Object?> json, {
    required SearchResultType fallbackType,
  }) {
    final profile = _firstMapFrom(json, const [
      'profile',
      'provider',
      'user',
      'account',
    ]);
    final category = _mapFrom(json['category']);
    final type = _typeFromValue(
      _readString(json, const ['type', 'result_type', 'resultType', 'kind']),
      fallbackType,
    );

    return SearchResultDto(
      id: _readString(json, const [
        'id',
        'profile_id',
        'service_id',
        'offer_id',
        'ad_id',
      ]),
      type: type,
      title: _readTitle(json, profile, type),
      subtitle: _readString(json, const ['subtitle', 'summary']),
      description: _readString(json, const ['description', 'bio', 'details']),
      imageUrl: _readImageUrl(json),
      username:
          _readString(json, const ['username']) ??
          _readString(profile, const ['username']),
      accountType:
          _readString(json, const ['account_type', 'accountType']) ??
          _readString(profile, const ['account_type', 'accountType']),
      location: _readString(json, const ['location', 'city']),
      isVerified:
          _readBool(json, const ['is_verified', 'isVerified']) ||
          _readBool(profile, const ['is_verified', 'isVerified']),
      isFeatured: _readBool(json, const ['is_featured', 'isFeatured']),
      price: _readNum(json, const ['price', 'offer_price', 'amount']),
      currency: _readString(json, const ['currency']),
      categoryName:
          _readString(json, const ['category_name', 'categoryName']) ??
          _readCategoryName(category),
      provider: profile == null
          ? null
          : SearchResultProviderDto.fromJson(profile),
    );
  }

  SearchResult? toDomain({
    required String fallbackId,
    required String fallbackCurrency,
  }) {
    final resolvedTitle = title ?? username;
    if (resolvedTitle == null || resolvedTitle.trim().isEmpty) {
      return null;
    }

    final resolvedId = id ?? fallbackId;
    final resolvedProvider = provider?.toDomain(
      fallbackId: '$resolvedId-provider',
    );
    final resolvedPrice = price == null
        ? null
        : SearchResultPrice(
            amount: price!,
            currency: _cleanCurrency(currency) ?? fallbackCurrency,
          );

    return switch (type) {
      SearchResultType.profile => SearchProfileResult(
        id: resolvedId,
        title: resolvedTitle,
        username: username,
        accountType: accountType,
        location: location,
        isVerified: isVerified,
        description: description,
        imageUrl: imageUrl,
      ),
      SearchResultType.service => SearchServiceResult(
        id: resolvedId,
        title: resolvedTitle,
        description: description,
        imageUrl: imageUrl,
        provider: resolvedProvider,
        price: resolvedPrice,
        categoryName: categoryName,
      ),
      SearchResultType.offer => SearchOfferResult(
        id: resolvedId,
        title: resolvedTitle,
        description: description,
        imageUrl: imageUrl,
        provider: resolvedProvider,
        price: resolvedPrice,
        categoryName: categoryName,
        isFeatured: isFeatured,
      ),
      SearchResultType.ad => SearchAdResult(
        id: resolvedId,
        title: resolvedTitle,
        description: description,
        imageUrl: imageUrl,
        provider: resolvedProvider,
      ),
      SearchResultType.unknown => SearchUnknownResult(
        id: resolvedId,
        title: resolvedTitle,
        subtitle: subtitle,
        description: description,
        imageUrl: imageUrl,
        provider: resolvedProvider,
      ),
    };
  }
}

class SearchResultProviderDto {
  const SearchResultProviderDto({
    this.id,
    this.name,
    this.username,
    this.avatarUrl,
    this.accountType,
    this.isVerified = false,
  });

  final String? id;
  final String? name;
  final String? username;
  final String? avatarUrl;
  final String? accountType;
  final bool isVerified;

  factory SearchResultProviderDto.fromJson(Map<String, Object?> json) {
    return SearchResultProviderDto(
      id: _readString(json, const ['id', 'profile_id', 'provider_id']),
      name: _readString(json, const [
        'full_name',
        'display_name',
        'name',
        'username',
      ]),
      username: _readString(json, const ['username']),
      avatarUrl: _readString(json, const ['avatar_url', 'avatarUrl']),
      accountType: _readString(json, const ['account_type', 'accountType']),
      isVerified: _readBool(json, const ['is_verified', 'isVerified']),
    );
  }

  SearchResultProvider toDomain({required String fallbackId}) {
    return SearchResultProvider(
      id: id ?? fallbackId,
      name: name ?? username ?? 'Provider',
      username: username,
      avatarUrl: avatarUrl,
      accountType: accountType,
      isVerified: isVerified,
    );
  }
}

SearchResultType _typeFromValue(String? value, SearchResultType fallbackType) {
  return switch (value?.trim().toLowerCase()) {
    'profile' || 'profiles' => SearchResultType.profile,
    'service' || 'services' => SearchResultType.service,
    'offer' || 'offers' => SearchResultType.offer,
    'ad' || 'ads' => SearchResultType.ad,
    _ => fallbackType,
  };
}

String? _readTitle(
  Map<String, Object?> json,
  Map<String, Object?>? profile,
  SearchResultType type,
) {
  final keys = switch (type) {
    SearchResultType.profile => const [
      'full_name',
      'display_name',
      'name',
      'title',
      'username',
    ],
    _ => const ['title', 'name', 'service_name', 'offer_title'],
  };

  return _readString(json, keys) ??
      _readString(profile, const [
        'full_name',
        'display_name',
        'name',
        'username',
      ]);
}

String? _readImageUrl(Map<String, Object?> json) {
  final direct = _readString(json, const [
    'avatar_url',
    'avatarUrl',
    'image_url',
    'imageUrl',
    'cover_url',
    'coverUrl',
    'thumbnail_url',
    'thumbnailUrl',
  ]);
  if (direct != null) {
    return direct;
  }

  final images = _readStringList(json, const [
    'media_urls',
    'mediaUrls',
    'image_urls',
    'imageUrls',
    'images',
  ]);
  return images.isEmpty ? null : images.first;
}

String? _readCategoryName(Map<String, Object?>? category) {
  return _readString(category, const [
    'name',
    'name_en',
    'nameEn',
    'name_ar',
    'nameAr',
  ]);
}

Map<String, Object?>? _readMeta(Object? value) {
  final map = _mapFrom(value);
  if (map == null) {
    return null;
  }

  return _mapFrom(map['meta']) ?? map;
}

List? _firstListFrom(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is List) {
      return value;
    }
  }
  return null;
}

Map<String, Object?>? _firstMapFrom(
  Map<String, Object?> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = _mapFrom(map[key]);
    if (value != null) {
      return value;
    }
  }
  return null;
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

num? _readNum(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
  }
  return null;
}

int? _readInt(Map<String, Object?>? map, List<String> keys) {
  final value = _readNum(map, keys);
  return value?.toInt();
}

bool _readBool(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return false;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }
  }
  return false;
}

List<String> _readStringList(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is List) {
      return [
        for (final item in value)
          if (item is String && item.trim().isNotEmpty) item.trim(),
      ];
    }
  }
  return const [];
}

String? _cleanCurrency(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value.trim().toUpperCase();
}
