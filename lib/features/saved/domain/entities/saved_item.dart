/// A bookmarked item as shown on the Saved screen. `id` is the *saved-row* id
/// (used to remove it via `DELETE /saved/:id`), distinct from [itemId] which is
/// the underlying offer/service/ad/profile id.
class SavedItem {
  const SavedItem({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  final String id;
  final String itemId;

  /// One of: offer, service, ad, profile.
  final String itemType;

  final String title;
  final String? subtitle;
  final String? imageUrl;
}
