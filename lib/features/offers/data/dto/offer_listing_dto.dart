import '../../domain/entities/offer_listing.dart';

/// Parses `GET /offers/profile/:id` rows — a fixed backend shape (this app's
/// own `offer.service.ts`, not a third-party feed), so no defensive
/// multi-alias reading is needed, unlike `services_dto.dart`.
class OfferListingDto {
  const OfferListingDto({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.offerPrice,
    this.categoryId,
    this.categoryName,
    this.originalPrice,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.mediaUrls = const [],
    this.tags = const [],
  });

  final String id;
  final String status;
  final String title;
  final String description;
  final num offerPrice;
  final String? categoryId;
  final String? categoryName;
  final num? originalPrice;
  final int? discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> mediaUrls;
  final List<String> tags;

  factory OfferListingDto.fromJson(Map<String, Object?> json) {
    final category = json['category'];
    final categoryMap = category is Map
        ? Map<String, Object?>.from(category)
        : null;

    return OfferListingDto(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      offerPrice: (json['offer_price'] as num?) ?? 0,
      categoryId: json['category_id'] as String?,
      categoryName:
          categoryMap?['name_en'] as String? ??
          categoryMap?['name_ar'] as String?,
      originalPrice: json['original_price'] as num?,
      discountPercentage: (json['discount_percentage'] as num?)?.toInt(),
      startDate: DateTime.tryParse(json['start_date'] as String? ?? ''),
      endDate: json['end_date'] == null
          ? null
          : DateTime.tryParse(json['end_date'] as String? ?? ''),
      mediaUrls: [
        for (final url in (json['media_urls'] as List?) ?? const [])
          if (url is String) url,
      ],
      tags: [
        for (final tag in (json['tags'] as List?) ?? const [])
          if (tag is String) tag,
      ],
    );
  }

  OfferListing toDomain() {
    return OfferListing(
      id: id,
      status: status,
      title: title,
      description: description,
      offerPrice: offerPrice,
      categoryId: categoryId,
      categoryName: categoryName,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      startDate: startDate,
      endDate: endDate,
      mediaUrls: mediaUrls,
      tags: tags,
    );
  }
}

List<OfferListing> parseOfferListings(Object? data) {
  final list = data is List ? data : (data is Map ? data['data'] : null);
  if (list is! List) return const [];

  return [
    for (final row in list)
      if (row is Map)
        OfferListingDto.fromJson(Map<String, Object?>.from(row)).toDomain(),
  ];
}
