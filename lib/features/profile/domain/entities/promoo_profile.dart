enum ProfileAccountType { company, influencer, serviceProvider, user, unknown }

extension ProfileAccountTypeValue on ProfileAccountType {
  static ProfileAccountType fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'company' => ProfileAccountType.company,
      'influencer' => ProfileAccountType.influencer,
      'service_provider' => ProfileAccountType.serviceProvider,
      'serviceprovider' => ProfileAccountType.serviceProvider,
      'user' => ProfileAccountType.user,
      _ => ProfileAccountType.unknown,
    };
  }

  String get label {
    return switch (this) {
      ProfileAccountType.company => 'Company',
      ProfileAccountType.influencer => 'Influencer',
      ProfileAccountType.serviceProvider => 'Service provider',
      ProfileAccountType.user => 'User',
      ProfileAccountType.unknown => 'Promoo profile',
    };
  }
}

class PromooProfile {
  const PromooProfile({
    required this.id,
    required this.displayName,
    required this.accountType,
    required this.stats,
    this.username,
    this.bio,
    this.location,
    this.website,
    this.avatarUrl,
    this.coverUrl,
    this.categoryName,
    this.socialLinks = const {},
    this.mediaUrls = const [],
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String id;
  final String displayName;
  final String? username;
  final String? bio;
  final String? location;
  final String? website;
  final String? avatarUrl;
  final String? coverUrl;
  final String? categoryName;
  final ProfileAccountType accountType;
  final ProfileStats stats;
  final Map<String, String> socialLinks;
  final List<String> mediaUrls;
  final bool isVerified;
  final bool isFeatured;

  String get handle => username == null ? '@promoo' : '@$username';
}

class ProfileStats {
  const ProfileStats({
    this.followers = 0,
    this.following = 0,
    this.offers = 0,
    this.services = 0,
  });

  final int followers;
  final int following;
  final int offers;
  final int services;
}

class ProfilePackage {
  const ProfilePackage({
    required this.id,
    required this.title,
    this.description,
    this.price,
    this.categoryName,
    this.imageUrls = const [],
    this.deliveryDays,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String? description;
  final ProfilePackagePrice? price;
  final String? categoryName;
  final List<String> imageUrls;
  final int? deliveryDays;
  final List<String> tags;
}

class ProfilePackagePrice {
  const ProfilePackagePrice({required this.amount, required this.currency});

  final num amount;
  final String currency;

  String get label {
    final amountLabel = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$amountLabel $currency';
  }
}

class ProfileUpdateDraft {
  const ProfileUpdateDraft({
    this.displayName,
    this.username,
    this.bio,
    this.location,
    this.website,
  });

  final String? displayName;
  final String? username;
  final String? bio;
  final String? location;
  final String? website;
}
