enum SearchResultType { profile, service, offer, unknown }

enum SearchFilterType { all, profiles, influencers, services, offers }

extension SearchFilterTypeValue on SearchFilterType {
  String get label {
    return switch (this) {
      SearchFilterType.all => 'All',
      SearchFilterType.profiles => 'Profiles',
      SearchFilterType.influencers => 'Influencers',
      SearchFilterType.services => 'Services',
      SearchFilterType.offers => 'Offers',
    };
  }

  String get apiType {
    return switch (this) {
      SearchFilterType.all => 'all',
      SearchFilterType.profiles => 'profiles',
      SearchFilterType.influencers => 'profiles',
      SearchFilterType.services => 'services',
      SearchFilterType.offers => 'offers',
    };
  }

  String? get accountType {
    return this == SearchFilterType.influencers ? 'influencer' : null;
  }

  SearchResultType get fallbackResultType {
    return switch (this) {
      SearchFilterType.profiles ||
      SearchFilterType.influencers => SearchResultType.profile,
      SearchFilterType.services => SearchResultType.service,
      SearchFilterType.offers => SearchResultType.offer,
      SearchFilterType.all => SearchResultType.unknown,
    };
  }
}

class SearchResultsPage {
  const SearchResultsPage({
    required this.results,
    this.page = 1,
    this.limit = 20,
    this.total,
    this.totalPages,
  });

  final List<SearchResult> results;
  final int page;
  final int limit;
  final int? total;
  final int? totalPages;

  bool get isEmpty => results.isEmpty;
}

abstract class SearchResult {
  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.provider,
  });

  final String id;
  final SearchResultType type;
  final String title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final SearchResultProvider? provider;
}

class SearchProfileResult extends SearchResult {
  const SearchProfileResult({
    required super.id,
    required super.title,
    this.username,
    this.accountType,
    this.location,
    this.isVerified = false,
    super.description,
    super.imageUrl,
  }) : super(
         type: SearchResultType.profile,
         subtitle: username == null ? accountType : '@$username',
       );

  final String? username;
  final String? accountType;
  final String? location;
  final bool isVerified;
}

class SearchServiceResult extends SearchResult {
  const SearchServiceResult({
    required super.id,
    required super.title,
    this.price,
    this.categoryName,
    super.description,
    super.imageUrl,
    super.provider,
  }) : super(type: SearchResultType.service, subtitle: categoryName);

  final SearchResultPrice? price;
  final String? categoryName;
}

class SearchOfferResult extends SearchResult {
  const SearchOfferResult({
    required super.id,
    required super.title,
    this.price,
    this.categoryName,
    this.isFeatured = false,
    super.description,
    super.imageUrl,
    super.provider,
  }) : super(type: SearchResultType.offer, subtitle: categoryName);

  final SearchResultPrice? price;
  final String? categoryName;
  final bool isFeatured;
}

class SearchUnknownResult extends SearchResult {
  const SearchUnknownResult({
    required super.id,
    required super.title,
    super.subtitle,
    super.description,
    super.imageUrl,
    super.provider,
  }) : super(type: SearchResultType.unknown);
}

class SearchResultProvider {
  const SearchResultProvider({
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

class SearchResultPrice {
  const SearchResultPrice({required this.amount, required this.currency});

  final num amount;
  final String currency;

  String get label {
    final amountLabel = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$amountLabel $currency';
  }
}
