import '../../domain/entities/ad_listing.dart';

/// Parses `GET /ads/profile/:id` rows — a fixed backend shape (this app's own
/// `ad.service.ts`), so no defensive multi-alias reading is needed.
AdListing _adListingFromJson(Map<String, Object?> json) {
  return AdListing(
    id: json['id'] as String? ?? '',
    status: json['status'] as String? ?? 'pending',
    title: json['title'] as String? ?? '',
    mediaUrl: json['media_url'] as String? ?? '',
    adType: json['ad_type'] as String? ?? 'banner',
    budget: json['budget'] as num?,
    startDate: json['start_date'] == null
        ? null
        : DateTime.tryParse(json['start_date'] as String? ?? ''),
    description: json['description'] as String?,
    endDate: json['end_date'] == null
        ? null
        : DateTime.tryParse(json['end_date'] as String? ?? ''),
    phone: json['phone'] as String?,
    whatsapp: json['whatsapp'] as String?,
    contactEmail: json['contact_email'] as String?,
    instagramLink: json['instagram_link'] as String?,
    city: json['city'] as String?,
    area: json['area'] as String?,
    fullAddress: json['full_address'] as String?,
    locationMapUrl: json['location_map_url'] as String?,
    price: json['price'] as num?,
    currency: json['currency'] as String?,
    serviceType: json['service_type'] as String?,
    paymentMethod: json['payment_method'] as String?,
    tags: [
      for (final tag in (json['tags'] as List?) ?? const [])
        if (tag is String) tag,
    ],
  );
}

List<AdListing> parseAdListings(Object? data) {
  final list = data is List ? data : (data is Map ? data['data'] : null);
  if (list is! List) return const [];

  return [
    for (final row in list)
      if (row is Map) _adListingFromJson(Map<String, Object?>.from(row)),
  ];
}
