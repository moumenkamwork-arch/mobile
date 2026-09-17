/// The fields the Add Offer form collects, mapped 1:1 to `POST /offers`
/// (`createOfferSchema`). `mediaUrls` are Supabase Storage URLs already
/// produced by the Upload step (`bucket: offers`).
class OfferDraft {
  const OfferDraft({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.offerPrice,
    required this.startDate,
    this.originalPrice,
    this.discountPercentage,
    this.endDate,
    this.mediaUrls = const [],
    this.tags = const [],
  });

  final String categoryId;
  final String title;
  final String description;
  final num offerPrice;
  final DateTime startDate;
  final num? originalPrice;
  final int? discountPercentage;
  final DateTime? endDate;
  final List<String> mediaUrls;
  final List<String> tags;
}
