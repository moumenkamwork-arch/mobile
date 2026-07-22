/// An existing offer as returned by `GET /offers/profile/:id` (My Listings +
/// edit-prefill). Mirrors [OfferDraft] field-for-field plus `id`/`status`.
class OfferListing {
  const OfferListing({
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

  /// One of: draft, active, expired, rejected.
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

  String? get imageUrl => mediaUrls.isEmpty ? null : mediaUrls.first;
}
