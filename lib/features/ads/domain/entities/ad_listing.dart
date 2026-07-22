/// An existing ad as returned by `GET /ads/profile/:id` (My Listings +
/// edit-prefill). Mirrors [AdDraft] field-for-field plus `id`/`status`.
class AdListing {
  const AdListing({
    required this.id,
    required this.status,
    required this.title,
    required this.mediaUrl,
    this.adType = 'banner',
    this.budget,
    this.startDate,
    this.description,
    this.endDate,
    this.phone,
    this.whatsapp,
    this.contactEmail,
    this.instagramLink,
    this.city,
    this.area,
    this.fullAddress,
    this.locationMapUrl,
    this.price,
    this.currency,
    this.serviceType,
    this.paymentMethod,
    this.tags = const [],
  });

  final String id;

  /// One of: pending, active, paused, completed, rejected.
  final String status;
  final String title;
  final String mediaUrl;
  final String adType;
  final num? budget;
  final DateTime? startDate;
  final String? description;
  final DateTime? endDate;
  final String? phone;
  final String? whatsapp;
  final String? contactEmail;
  final String? instagramLink;
  final String? city;
  final String? area;
  final String? fullAddress;
  final String? locationMapUrl;
  final num? price;
  final String? currency;
  final String? serviceType;
  final String? paymentMethod;
  final List<String> tags;
}
