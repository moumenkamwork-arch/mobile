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
