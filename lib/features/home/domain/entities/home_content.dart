class HomeContent {
  const HomeContent({
    this.highlight,
    this.categories = const [],
    this.services = const [],
    this.offers = const [],
    this.profiles = const [],
    this.stories = const [],
  });

  final HomeHighlight? highlight;
  final List<HomeCategory> categories;
  final List<HomeServicePreview> services;
  final List<HomeOfferPreview> offers;
  final List<HomeProfilePreview> profiles;
  final List<HomeStory> stories;

  bool get isEmpty {
    return highlight == null &&
        categories.isEmpty &&
        services.isEmpty &&
        offers.isEmpty &&
        profiles.isEmpty &&
        stories.isEmpty;
  }
}

enum HomeContentDetailType { offer, ad, unknown }

extension HomeContentDetailTypeValue on HomeContentDetailType {
  String get routeValue {
    return switch (this) {
      HomeContentDetailType.offer => 'offer',
      HomeContentDetailType.ad => 'ad',
      HomeContentDetailType.unknown => 'unknown',
    };
  }

  /// Data-layer-only fallback used when a fixture/backend record omits
  /// `title`/`badge` (see `HomeContentDetailDto.toDomain`). English-only and
  /// NOT shown as-is by the UI — the presentation layer resolves its own
  /// localized label via `homeContentDetailTypeLabel(context, type)` for
  /// actual display. Domain code has no `BuildContext` to localize this.
  String get dataFallbackLabel {
    return switch (this) {
      HomeContentDetailType.offer => 'Offer',
      HomeContentDetailType.ad => 'Promotion',
      HomeContentDetailType.unknown => 'Promoo item',
    };
  }

  static HomeContentDetailType fromRouteValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'offer' ||
      'offers' ||
      'promotion' ||
      'promotions' ||
      'for-you' => HomeContentDetailType.offer,
      'ad' || 'ads' => HomeContentDetailType.ad,
      _ => HomeContentDetailType.unknown,
    };
  }
}

class HomeContentDetailRequest {
  const HomeContentDetailRequest({required this.type, required this.id});

  final HomeContentDetailType type;
  final String id;

  bool get isValid =>
      type != HomeContentDetailType.unknown && id.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeContentDetailRequest &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            id == other.id;
  }

  @override
  int get hashCode => Object.hash(type, id);
}

class HomeHighlight {
  const HomeHighlight({
    required this.id,
    required this.title,
    this.detailType = HomeContentDetailType.offer,
    this.subtitle,
    this.imageUrl,
    this.badge,
    this.actionLabel,
  });

  final String id;
  final String title;
  final HomeContentDetailType detailType;
  final String? subtitle;
  final String? imageUrl;
  final String? badge;
  final String? actionLabel;
}

class HomeCategory {
  const HomeCategory({required this.id, required this.name, this.iconUrl});

  final String id;
  final String name;
  final String? iconUrl;
}

class HomeServicePreview {
  const HomeServicePreview({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.categoryName,
    this.location,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? categoryName;
  final String? location;
}

class HomeOfferPreview {
  const HomeOfferPreview({
    required this.id,
    required this.title,
    this.detailType = HomeContentDetailType.offer,
    this.subtitle,
    this.imageUrl,
  });

  final String id;
  final String title;
  final HomeContentDetailType detailType;
  final String? subtitle;
  final String? imageUrl;
}

class HomeProfilePreview {
  const HomeProfilePreview({
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

class HomeStory {
  const HomeStory({
    required this.id,
    required this.title,
    this.imageUrl,
    this.profileName,
    this.profileAvatarUrl,
    this.items = const [],
  });

  final String id;
  final String title;
  final String? imageUrl;
  final String? profileName;
  final String? profileAvatarUrl;
  final List<HomeStoryItem> items;

  List<HomeStoryItem> get effectiveItems {
    if (items.isNotEmpty) {
      return items;
    }
    return [HomeStoryItem(id: id, title: title, imageUrl: imageUrl)];
  }
}

class HomeStoryItem {
  const HomeStoryItem({required this.id, required this.title, this.imageUrl});

  final String id;
  final String title;
  final String? imageUrl;
}

class HomeContentDetail {
  const HomeContentDetail({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.imageUrl,
    this.badge,
    this.provider,
    this.categoryName,
    this.tags = const [],
    this.price,
    this.location,
    this.promoCode,
    this.validUntil,
    this.terms,
  });

  final String id;
  final HomeContentDetailType type;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? badge;
  final HomeContentProvider? provider;
  final String? categoryName;
  final List<String> tags;
  final HomeContentPrice? price;
  final String? location;
  final String? promoCode;
  final String? validUntil;
  final String? terms;

  bool get hasDetails {
    return tags.isNotEmpty ||
        promoCode != null ||
        validUntil != null ||
        terms != null ||
        location != null;
  }
}

class HomeContentProvider {
  const HomeContentProvider({
    required this.id,
    this.name,
    this.username,
    this.avatarUrl,
    this.accountType,
    this.isVerified = false,
  });

  final String id;
  final String? name;
  final String? username;
  final String? avatarUrl;
  final String? accountType;
  final bool isVerified;

  String get displayName => name ?? username ?? 'Provider profile';
}

class HomeContentPrice {
  const HomeContentPrice({required this.amount, required this.currency});

  final num amount;
  final String currency;

  String get label {
    final amountLabel = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$amountLabel $currency';
  }
}
