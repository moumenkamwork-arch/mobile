/// Fields the Add Ad wizard collects, mapped to `POST /ads` (`createAdSchema`).
///
/// Two schema-required fields have no MVP UI (owner-approved 2026-07: send
/// defaults): `adType` defaults to `banner`, and `budget` is nominal in v1
/// (there's no real ad payment — an ad is created `pending` and an admin
/// activates it), so it defaults to the entered [price] or `1`. [mediaUrl] is
/// a single Storage URL from the Upload step (the ad schema takes one image,
/// not an array).
class AdDraft {
  const AdDraft({
    required this.title,
    required this.mediaUrl,
    required this.budget,
    required this.startDate,
    this.adType = 'banner',
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

  final String title;
  final String mediaUrl;
  final num budget;
  final DateTime startDate;
  final String adType;
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
