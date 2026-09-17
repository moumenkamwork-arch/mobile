class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    this.slug,
    this.nameAr,
    this.nameEn,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? slug;
  final String? nameAr;
  final String? nameEn;
  final String? imageUrl;
}

/// Fields the Add Service form collects, mapped 1:1 to `POST /services`
/// (`createServiceSchema`). `mediaUrls` are Storage URLs from the Upload step
/// (`bucket: services`).
class ServiceDraft {
  const ServiceDraft({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.deliveryDays,
    this.currency = 'AED',
    this.mediaUrls = const [],
    this.tags = const [],
  });

  final String categoryId;
  final String title;
  final String description;
  final num price;
  final int deliveryDays;
  final String currency;
  final List<String> mediaUrls;
  final List<String> tags;
}

class PromooService {
  const PromooService({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.provider,
    this.price,
    this.imageUrls = const [],
    this.location,
    this.deliveryDays,
    this.tags = const [],
    this.status,
  });

  final String id;
  final String title;
  final String? description;
  final ServiceCategory? category;
  final ServiceProvider? provider;
  final ServicePrice? price;
  final List<String> imageUrls;
  final String? location;
  final int? deliveryDays;
  final List<String> tags;

  /// One of: active, paused, deleted. Only populated by the My Listings
  /// fetch (`GET /services/profile/:id`) — the public feed/detail calls
  /// leave this `null` since every row there is already active.
  final String? status;

  bool get hasPrice => price != null;
}

class ServiceProvider {
  const ServiceProvider({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
    this.accountType,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;
  final String? accountType;
  final bool isVerified;
}

class ServicePrice {
  const ServicePrice({required this.amount, required this.currency});

  final num amount;
  final String currency;

  String get label {
    final amountLabel = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$amountLabel $currency';
  }
}
