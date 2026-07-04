import '../../domain/entities/promoo_service.dart';

class ServiceCategoryDto {
  const ServiceCategoryDto({
    this.id,
    this.name,
    this.nameAr,
    this.nameEn,
    this.slug,
    this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? slug;
  final String? imageUrl;

  factory ServiceCategoryDto.fromJson(Map<String, Object?> json) {
    final nameAr = _readString(json, const ['name_ar', 'nameAr']);
    final nameEn = _readString(json, const ['name_en', 'nameEn']);

    return ServiceCategoryDto(
      id: _readString(json, const ['id', 'category_id', 'slug']),
      name:
          _readString(json, const ['name', 'title', 'label']) ??
          nameEn ??
          nameAr,
      nameAr: nameAr,
      nameEn: nameEn,
      slug: _readString(json, const ['slug']),
      imageUrl: _readString(json, const [
        'image_url',
        'imageUrl',
        'cover_url',
        'coverUrl',
        'thumbnail_url',
        'thumbnailUrl',
        'icon_url',
        'iconUrl',
      ]),
    );
  }

  ServiceCategory toDomain({required String fallbackId}) {
    return ServiceCategory(
      id: id ?? fallbackId,
      name: name ?? nameEn ?? nameAr ?? 'Category',
      nameAr: nameAr,
      nameEn: nameEn,
      slug: slug,
      imageUrl: imageUrl,
    );
  }
}

class ServiceCategoriesDto {
  const ServiceCategoriesDto(this.categories);

  final List<ServiceCategoryDto> categories;

  factory ServiceCategoriesDto.empty() {
    return const ServiceCategoriesDto([]);
  }

  factory ServiceCategoriesDto.fromJsonFlexible(Object? value) {
    return ServiceCategoriesDto(
      _mapsFrom(value).map(ServiceCategoryDto.fromJson).toList(growable: false),
    );
  }

  List<ServiceCategory> toDomain() {
    return [
      for (var i = 0; i < categories.length; i++)
        if (categories[i].name != null ||
            categories[i].nameEn != null ||
            categories[i].nameAr != null)
          categories[i].toDomain(fallbackId: 'category-$i'),
    ];
  }
}

class PromooServiceDto {
  const PromooServiceDto({
    this.id,
    this.title,
    this.description,
    this.category,
    this.provider,
    this.price,
    this.currency,
    this.imageUrls = const [],
    this.location,
    this.deliveryDays,
    this.tags = const [],
  });

  final String? id;
  final String? title;
  final String? description;
  final ServiceCategoryDto? category;
  final ServiceProviderDto? provider;
  final num? price;
  final String? currency;
  final List<String> imageUrls;
  final String? location;
  final int? deliveryDays;
  final List<String> tags;

  factory PromooServiceDto.fromJson(Map<String, Object?> json) {
    final category = _mapFrom(json['category']);
    final profile = _mapFrom(json['profile']) ?? _mapFrom(json['provider']);

    return PromooServiceDto(
      id: _readString(json, const ['id', 'service_id']),
      title: _readString(json, const ['title', 'name', 'service_name']),
      description: _readString(json, const [
        'description',
        'subtitle',
        'short_description',
        'summary',
      ]),
      category: category == null ? null : ServiceCategoryDto.fromJson(category),
      provider: profile == null ? null : ServiceProviderDto.fromJson(profile),
      price: _readNum(json, const ['price', 'amount']),
      currency: _readString(json, const ['currency']),
      imageUrls:
          _readStringList(json, const [
            'media_urls',
            'mediaUrls',
            'image_urls',
            'imageUrls',
            'images',
          ]).isEmpty
          ? [
              if (_readString(json, const [
                    'image_url',
                    'imageUrl',
                    'cover_url',
                    'coverUrl',
                    'thumbnail_url',
                    'thumbnailUrl',
                  ]) !=
                  null)
                _readString(json, const [
                  'image_url',
                  'imageUrl',
                  'cover_url',
                  'coverUrl',
                  'thumbnail_url',
                  'thumbnailUrl',
                ])!,
            ]
          : _readStringList(json, const [
              'media_urls',
              'mediaUrls',
              'image_urls',
              'imageUrls',
              'images',
            ]),
      location:
          _readString(json, const ['location', 'city', 'address']) ??
          (profile == null
              ? null
              : _readString(profile, const ['location', 'city', 'address'])),
      deliveryDays: _readInt(json, const ['delivery_days', 'deliveryDays']),
      tags: _readStringList(json, const ['tags']),
    );
  }

  PromooService toDomain({
    required String fallbackId,
    required String fallbackCurrency,
  }) {
    return PromooService(
      id: id ?? fallbackId,
      title: title ?? 'Service',
      description: description,
      category: category?.toDomain(fallbackId: '$fallbackId-category'),
      provider: provider?.toDomain(fallbackId: '$fallbackId-provider'),
      price: price == null
          ? null
          : ServicePrice(
              amount: price!,
              currency: _cleanCurrency(currency) ?? fallbackCurrency,
            ),
      imageUrls: imageUrls,
      location: location,
      deliveryDays: deliveryDays,
      tags: tags,
    );
  }
}

class ServiceProviderDto {
  const ServiceProviderDto({
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

  factory ServiceProviderDto.fromJson(Map<String, Object?> json) {
    return ServiceProviderDto(
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

  ServiceProvider toDomain({required String fallbackId}) {
    return ServiceProvider(
      id: id ?? fallbackId,
      name: name ?? username ?? 'Provider',
      username: username,
      avatarUrl: avatarUrl,
      accountType: accountType,
      isVerified: isVerified,
    );
  }
}

class PromooServicesDto {
  const PromooServicesDto(this.services);

  final List<PromooServiceDto> services;

  factory PromooServicesDto.empty() {
    return const PromooServicesDto([]);
  }

  factory PromooServicesDto.fromJsonFlexible(Object? value) {
    return PromooServicesDto(
      _mapsFrom(value).map(PromooServiceDto.fromJson).toList(growable: false),
    );
  }

  List<PromooService> toDomain({required String fallbackCurrency}) {
    return [
      for (var i = 0; i < services.length; i++)
        if (services[i].title != null)
          services[i].toDomain(
            fallbackId: 'service-$i',
            fallbackCurrency: fallbackCurrency,
          ),
    ];
  }
}

Object? _unwrapListContainer(Object? value) {
  if (value is List) {
    return value;
  }

  final map = _mapFrom(value);
  if (map == null) {
    return value;
  }

  for (final key in const [
    'data',
    'items',
    'results',
    'services',
    'categories',
    'records',
  ]) {
    final nested = map[key];
    if (nested is List) {
      return nested;
    }
    if (nested is Map) {
      return _unwrapListContainer(nested);
    }
  }

  return value;
}

List<Map<String, Object?>> _mapsFrom(Object? value) {
  final unwrapped = _unwrapListContainer(value);
  if (unwrapped is List) {
    final maps = <Map<String, Object?>>[];
    for (final item in unwrapped) {
      final mapped = _mapFrom(item);
      if (mapped != null) {
        maps.add(mapped);
      }
    }
    return maps;
  }

  final single = _mapFrom(unwrapped);
  if (single == null) {
    return const [];
  }
  return [single];
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

String? _readString(Map<String, Object?> map, List<String> keys) {
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

num? _readNum(Map<String, Object?> map, List<String> keys) {
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

int? _readInt(Map<String, Object?> map, List<String> keys) {
  final value = _readNum(map, keys);
  return value?.toInt();
}

bool _readBool(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
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
