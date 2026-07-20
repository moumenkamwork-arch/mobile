import '../../domain/entities/home_content.dart';

const _demoBusinessImage =
    'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80';
const _demoCafeImage =
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80';
const _demoBeautyImage =
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80';
const _demoDigitalImage =
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80';
const _demoFoodImage =
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80';
const _demoEventImage =
    'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=900&q=80';
const _demoPhotographyImage =
    'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&w=900&q=80';
const _demoLifestyleImage =
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80';
const _demoWellnessImage =
    'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=900&q=80';
const _demoTeamImage =
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=900&q=80';
const _demoCreatorImage =
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=900&q=80';

const _demoAvatarMaya =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80';
const _demoAvatarOmar =
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80';
const _demoAvatarLina =
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=240&q=80';
const _demoAvatarAdam =
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=240&q=80';
const _demoAvatarNadine =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=240&q=80';

class HomeContentDto {
  const HomeContentDto({
    this.highlight,
    this.categories = const [],
    this.services = const [],
    this.offers = const [],
    this.profiles = const [],
    this.stories = const [],
  });

  final HomeHighlightDto? highlight;
  final List<HomeCategoryDto> categories;
  final List<HomeServicePreviewDto> services;
  final List<HomeOfferPreviewDto> offers;
  final List<HomeProfilePreviewDto> profiles;
  final List<HomeStoryDto> stories;

  factory HomeContentDto.empty() {
    return const HomeContentDto();
  }

  factory HomeContentDto.fromJsonFlexible(Object? value) {
    if (value == null) {
      return HomeContentDto.empty();
    }

    final root = _mapFrom(value);
    if (root == null) {
      throw const FormatException(
        'Expected home response data to be an object.',
      );
    }

    final source = _homeSource(root);
    final promooOfTheDay = _mapFrom(
      _firstPresent(source, const [
        'promoo_of_the_day',
        'promooOfTheDay',
        'highlight',
        'featured',
        'featured_offer',
      ]),
    );
    final firstAd = _firstMapFrom(
      _firstPresent(source, const ['ads', 'banners', 'promotions']),
    );

    return HomeContentDto(
      highlight: promooOfTheDay != null
          ? HomeHighlightDto.fromJson(
              promooOfTheDay,
              fallbackType: HomeContentDetailType.offer,
            )
          : firstAd == null
          ? null
          : HomeHighlightDto.fromJson(
              firstAd,
              fallbackBadge: 'Promoted',
              fallbackType: HomeContentDetailType.ad,
            ),
      stories: _mapsFrom(
        _firstPresent(source, const ['stories', 'highlights']),
      ).map(HomeStoryDto.fromJson).toList(growable: false),
      categories: _mapsFrom(
        source['categories'],
      ).map(HomeCategoryDto.fromJson).toList(growable: false),
      profiles: _mapsFrom(
        _firstPresent(source, const [
          'featured_profiles',
          'featuredProfiles',
          'profiles',
          'influencers',
        ]),
      ).map(HomeProfilePreviewDto.fromJson).toList(growable: false),
      offers: _mapsFrom(
        _firstPresent(source, const [
          'latest_offers',
          'latestOffers',
          'offers',
          'promotions',
        ]),
      ).map(HomeOfferPreviewDto.fromJson).toList(growable: false),
      services: _mapsFrom(
        source['services'],
      ).map(HomeServicePreviewDto.fromJson).toList(growable: false),
    );
  }

  factory HomeContentDto.fixture() {
    return const HomeContentDto(
      highlight: HomeHighlightDto(
        id: 'offer-featured',
        title: 'Boutique launch visibility pack',
        subtitle: 'Premium placement for a curated brand launch across Promoo.',
        imageUrl: _demoBusinessImage,
        badge: 'Promoo of the day',
        actionLabel: 'View details',
      ),
      categories: [
        HomeCategoryDto(id: 'beauty-wellness', name: 'Beauty & Wellness'),
        HomeCategoryDto(id: 'restaurants-cafes', name: 'Restaurants & Cafes'),
        HomeCategoryDto(id: 'events-photography', name: 'Events & Photography'),
        HomeCategoryDto(
          id: 'influencer-campaigns',
          name: 'Influencer Campaigns',
        ),
      ],
      services: [
        HomeServicePreviewDto(
          id: 'service-influencer-launch',
          title: 'Boutique influencer launch package',
          subtitle: 'Curated creator coverage for launch campaigns',
          imageUrl: _demoCreatorImage,
          categoryName: 'Influencer Campaigns',
          location: 'Dubai',
        ),
        HomeServicePreviewDto(
          id: 'service-product-photography',
          title: 'Product photography session',
          subtitle: 'Editorial visuals for products and profiles',
          imageUrl: _demoPhotographyImage,
          categoryName: 'Events & Photography',
          location: 'Dubai',
        ),
        HomeServicePreviewDto(
          id: 'service-cafe-opening',
          title: 'Cafe promotion package',
          subtitle: 'Launch visibility for restaurants and cafes',
          imageUrl: _demoCafeImage,
          categoryName: 'Restaurants & Cafes',
          location: 'Sharjah',
        ),
        HomeServicePreviewDto(
          id: 'service-wellness-awareness',
          title: 'Wellness awareness package',
          subtitle: 'Premium reach for fitness and wellness brands',
          imageUrl: _demoWellnessImage,
          categoryName: 'Health & Fitness',
          location: 'Abu Dhabi',
        ),
        HomeServicePreviewDto(
          id: 'service-fashion-styling',
          title: 'Seasonal styling content pack',
          subtitle: 'Creator-ready visuals for fashion launches',
          imageUrl: _demoBeautyImage,
          categoryName: 'Fashion & Styling',
          location: 'Dubai',
        ),
      ],
      offers: [
        HomeOfferPreviewDto(
          id: 'offer-1',
          title: 'Cafe opening spotlight',
          subtitle: 'Discovery placement for a new cafe launch.',
          imageUrl: _demoCafeImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-2',
          title: 'Wellness week visibility',
          subtitle: 'Premium awareness push for wellness providers.',
          imageUrl: _demoWellnessImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-3',
          title: 'Beauty launch feature',
          subtitle: 'Editorial visibility for premium salon openings.',
          imageUrl: _demoBeautyImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-4',
          title: 'Creator campaign pick',
          subtitle: 'A curated campaign package selected for today.',
          imageUrl: _demoCreatorImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-5',
          title: 'Flash offer 24H',
          subtitle: 'Short-window placement for high-intent discovery.',
          imageUrl: _demoDigitalImage,
        ),
        HomeOfferPreviewDto(
          id: 'ad-1',
          title: 'Featured campaign spotlight',
          detailType: HomeContentDetailType.ad,
          subtitle: 'Prominent visibility for active launch campaigns.',
          imageUrl: _demoTeamImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-6',
          title: 'Restaurant reel boost',
          subtitle: 'Short-form food content for lunch and dinner discovery.',
          imageUrl: _demoFoodImage,
        ),
        HomeOfferPreviewDto(
          id: 'offer-7',
          title: 'Event coverage window',
          subtitle: 'Premium story coverage for weekend events.',
          imageUrl: _demoEventImage,
        ),
      ],
      profiles: [
        HomeProfilePreviewDto(
          id: 'profile-saffron-social',
          name: 'Saffron Social Studio',
          username: 'saffron.social',
          accountType: 'company',
          isVerified: true,
        ),
        HomeProfilePreviewDto(
          id: 'profile-lina-atelier',
          name: 'Lina Atelier',
          username: 'lina.atelier',
          accountType: 'influencer',
          isVerified: true,
        ),
      ],
      stories: [
        HomeStoryDto(
          id: 'story-maya',
          title: 'Launch day edits are ready for review.',
          imageUrl: _demoBusinessImage,
          profileName: 'Maya Studio',
          profileAvatarUrl: _demoAvatarMaya,
          items: [
            HomeStoryItemDto(
              id: 'story-maya-1',
              title: 'Launch day edits are ready for review.',
              imageUrl: _demoBusinessImage,
            ),
            HomeStoryItemDto(
              id: 'story-maya-2',
              title: 'Final campaign frames are being selected.',
              imageUrl: _demoTeamImage,
            ),
            HomeStoryItemDto(
              id: 'story-maya-3',
              title: 'Premium brand visuals go live tonight.',
              imageUrl: _demoDigitalImage,
            ),
          ],
        ),
        HomeStoryDto(
          id: 'story-omar',
          title: 'Event coverage slots opened for the weekend.',
          imageUrl: _demoEventImage,
          profileName: 'Omar Visuals',
          profileAvatarUrl: _demoAvatarOmar,
          items: [
            HomeStoryItemDto(
              id: 'story-omar-1',
              title: 'Event coverage slots opened for the weekend.',
              imageUrl: _demoEventImage,
            ),
            HomeStoryItemDto(
              id: 'story-omar-2',
              title: 'Behind-the-scenes reels are in progress.',
              imageUrl: _demoPhotographyImage,
            ),
            HomeStoryItemDto(
              id: 'story-omar-3',
              title: 'Weekend launch stories are filling quickly.',
              imageUrl: _demoTeamImage,
            ),
          ],
        ),
        HomeStoryDto(
          id: 'story-lina',
          title: 'New styling picks for premium creators.',
          imageUrl: _demoLifestyleImage,
          profileName: 'Lina Atelier',
          profileAvatarUrl: _demoAvatarLina,
          items: [
            HomeStoryItemDto(
              id: 'story-lina-1',
              title: 'New styling picks for premium creators.',
              imageUrl: _demoLifestyleImage,
            ),
            HomeStoryItemDto(
              id: 'story-lina-2',
              title: 'Soft neutral edits for summer campaigns.',
              imageUrl: _demoBeautyImage,
            ),
            HomeStoryItemDto(
              id: 'story-lina-3',
              title: 'Creator-ready looks are now available.',
              imageUrl: _demoCreatorImage,
            ),
          ],
        ),
        HomeStoryDto(
          id: 'story-pearl',
          title: 'Cafe launch tastings start this evening.',
          imageUrl: _demoFoodImage,
          profileName: 'Pearl District',
          profileAvatarUrl: _demoAvatarAdam,
          items: [
            HomeStoryItemDto(
              id: 'story-pearl-1',
              title: 'Cafe launch tastings start this evening.',
              imageUrl: _demoFoodImage,
            ),
            HomeStoryItemDto(
              id: 'story-pearl-2',
              title: 'New opening menu shots are ready.',
              imageUrl: _demoCafeImage,
            ),
            HomeStoryItemDto(
              id: 'story-pearl-3',
              title: 'Morning launch coverage starts tomorrow.',
              imageUrl: _demoBusinessImage,
            ),
          ],
        ),
        HomeStoryDto(
          id: 'story-calmfit',
          title: 'Wellness visibility package is live this week.',
          imageUrl: _demoWellnessImage,
          profileName: 'CalmFit',
          profileAvatarUrl: _demoAvatarNadine,
          items: [
            HomeStoryItemDto(
              id: 'story-calmfit-1',
              title: 'Wellness visibility package is live this week.',
              imageUrl: _demoWellnessImage,
            ),
            HomeStoryItemDto(
              id: 'story-calmfit-2',
              title: 'Recovery campaign slots are open.',
              imageUrl: _demoLifestyleImage,
            ),
            HomeStoryItemDto(
              id: 'story-calmfit-3',
              title: 'Mindful movement content is ready for launch.',
              imageUrl: _demoTeamImage,
            ),
          ],
        ),
      ],
    );
  }

  HomeContent toDomain() {
    return HomeContent(
      highlight: highlight?.toDomain(),
      categories: [
        for (var i = 0; i < categories.length; i++)
          if (categories[i].name != null)
            categories[i].toDomain(fallbackId: 'category-$i'),
      ],
      services: [
        for (var i = 0; i < services.length; i++)
          if (services[i].title != null)
            services[i].toDomain(fallbackId: 'service-$i'),
      ],
      offers: [
        for (var i = 0; i < offers.length; i++)
          if (offers[i].title != null)
            offers[i].toDomain(fallbackId: 'offer-$i'),
      ],
      profiles: [
        for (var i = 0; i < profiles.length; i++)
          if (profiles[i].name != null)
            profiles[i].toDomain(fallbackId: 'profile-$i'),
      ],
      stories: [
        for (var i = 0; i < stories.length; i++)
          if (stories[i].title != null)
            stories[i].toDomain(fallbackId: 'story-$i'),
      ],
    );
  }
}

class HomeHighlightDto {
  const HomeHighlightDto({
    this.id,
    this.title,
    this.detailType = HomeContentDetailType.offer,
    this.subtitle,
    this.imageUrl,
    this.badge,
    this.actionLabel,
  });

  final String? id;
  final String? title;
  final HomeContentDetailType detailType;
  final String? subtitle;
  final String? imageUrl;
  final String? badge;
  final String? actionLabel;

  factory HomeHighlightDto.fromJson(
    Map<String, Object?> json, {
    String? fallbackBadge,
    HomeContentDetailType fallbackType = HomeContentDetailType.offer,
  }) {
    // The backend returns offer/ad images as a `media_urls[]` array (see
    // HomeOfferPreviewDto) — fall back to its first element when no singular
    // image field is present. Without this, "Promoo of the day" rendered
    // the image placeholder even though the backend sent a real image.
    final mediaUrls = _readStringList(json, const [
      'media_urls',
      'mediaUrls',
      'image_urls',
      'imageUrls',
      'images',
    ]);
    return HomeHighlightDto(
      id: _readString(json, const ['id', 'offer_id', 'ad_id']),
      title: _readString(json, const ['title', 'name', 'headline']),
      detailType: _detailTypeFromValue(
        _readString(json, const ['type', 'kind', 'ad_type', 'content_type']),
        fallbackType,
      ),
      subtitle: _readString(json, const [
        'subtitle',
        'description',
        'summary',
        'body',
      ]),
      imageUrl:
          _readString(json, const [
            'image_url',
            'imageUrl',
            'banner_url',
            'media_url',
            'cover_url',
          ]) ??
          (mediaUrls.isEmpty ? null : mediaUrls.first),
      badge:
          _readString(json, const ['badge', 'label', 'placement']) ??
          fallbackBadge,
      actionLabel: _readString(json, const ['action_label', 'actionLabel']),
    );
  }

  HomeHighlight toDomain() {
    return HomeHighlight(
      id: id ?? title ?? 'home-highlight',
      title: title ?? 'Featured on Promoo',
      detailType: detailType,
      subtitle: subtitle,
      imageUrl: imageUrl,
      badge: badge ?? 'Featured',
      actionLabel: actionLabel ?? 'View details',
    );
  }
}

class HomeCategoryDto {
  const HomeCategoryDto({this.id, this.name, this.iconUrl});

  final String? id;
  final String? name;
  final String? iconUrl;

  factory HomeCategoryDto.fromJson(Map<String, Object?> json) {
    return HomeCategoryDto(
      id: _readString(json, const ['id', 'category_id', 'slug']),
      name: _readString(json, const ['name', 'title', 'label']),
      iconUrl: _readString(json, const ['icon_url', 'iconUrl', 'image_url']),
    );
  }

  HomeCategory toDomain({required String fallbackId}) {
    return HomeCategory(
      id: id ?? fallbackId,
      name: name ?? 'Category',
      iconUrl: iconUrl,
    );
  }
}

class HomeServicePreviewDto {
  const HomeServicePreviewDto({
    this.id,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.categoryName,
    this.location,
  });

  final String? id;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? categoryName;
  final String? location;

  factory HomeServicePreviewDto.fromJson(Map<String, Object?> json) {
    final category = _mapFrom(json['category']);
    // The backend returns service images as a `media_urls[]` array (see
    // HomeOfferPreviewDto) — fall back to its first element when no
    // singular image field is present.
    final mediaUrls = _readStringList(json, const [
      'media_urls',
      'mediaUrls',
      'image_urls',
      'imageUrls',
      'images',
    ]);

    return HomeServicePreviewDto(
      id: _readString(json, const ['id', 'service_id']),
      title: _readString(json, const ['title', 'name', 'service_name']),
      subtitle: _readString(json, const [
        'subtitle',
        'description',
        'short_description',
        'summary',
      ]),
      imageUrl:
          _readString(json, const [
            'image_url',
            'imageUrl',
            'cover_url',
            'thumbnail_url',
          ]) ??
          (mediaUrls.isEmpty ? null : mediaUrls.first),
      categoryName:
          _readString(json, const ['category_name', 'categoryName']) ??
          (category == null
              ? null
              : _readString(category, const ['name', 'title'])),
      location: _readString(json, const ['location', 'city', 'address']),
    );
  }

  HomeServicePreview toDomain({required String fallbackId}) {
    return HomeServicePreview(
      id: id ?? fallbackId,
      title: title ?? 'Service',
      subtitle: subtitle,
      imageUrl: imageUrl,
      categoryName: categoryName,
      location: location,
    );
  }
}

class HomeOfferPreviewDto {
  const HomeOfferPreviewDto({
    this.id,
    this.title,
    this.detailType = HomeContentDetailType.offer,
    this.subtitle,
    this.imageUrl,
  });

  final String? id;
  final String? title;
  final HomeContentDetailType detailType;
  final String? subtitle;
  final String? imageUrl;

  factory HomeOfferPreviewDto.fromJson(Map<String, Object?> json) {
    // The backend returns offer/ad images as a `media_urls[]` array; fall back
    // to its first element when no singular image field is present (mirrors
    // HomeContentDetailDto). Without this the home offer/ad cards render the
    // image placeholder even though the backend sent a real image.
    final mediaUrls = _readStringList(json, const [
      'media_urls',
      'mediaUrls',
      'image_urls',
      'imageUrls',
      'images',
    ]);
    return HomeOfferPreviewDto(
      id: _readString(json, const ['id', 'offer_id']),
      title: _readString(json, const ['title', 'name', 'headline']),
      detailType: _detailTypeFromValue(
        _readString(json, const ['type', 'kind', 'content_type']),
        HomeContentDetailType.offer,
      ),
      subtitle: _readString(json, const ['subtitle', 'description', 'summary']),
      imageUrl:
          _readString(json, const [
            'image_url',
            'imageUrl',
            'cover_url',
            'thumbnail_url',
          ]) ??
          (mediaUrls.isEmpty ? null : mediaUrls.first),
    );
  }

  HomeOfferPreview toDomain({required String fallbackId}) {
    return HomeOfferPreview(
      id: id ?? fallbackId,
      title: title ?? 'Offer',
      detailType: detailType,
      subtitle: subtitle,
      imageUrl: imageUrl,
    );
  }
}

class HomeProfilePreviewDto {
  const HomeProfilePreviewDto({
    this.id,
    this.name,
    this.username,
    this.avatarUrl,
    this.accountType,
    this.isVerified = false,
  });

  final String? id;
  final String? name;
  final String? username;
  final String? avatarUrl;
  final String? accountType;
  final bool isVerified;

  factory HomeProfilePreviewDto.fromJson(Map<String, Object?> json) {
    final profile = _mapFrom(json['profile']) ?? json;

    return HomeProfilePreviewDto(
      id:
          _readString(profile, const ['id', 'profile_id']) ??
          _readString(json, const ['id', 'profile_id']),
      name: _readString(profile, const [
        'full_name',
        'display_name',
        'name',
        'username',
      ]),
      username: _readString(profile, const ['username']),
      avatarUrl: _readString(profile, const ['avatar_url', 'avatarUrl']),
      accountType: _readString(profile, const ['account_type', 'accountType']),
      isVerified: _readBool(profile, const ['is_verified', 'isVerified']),
    );
  }

  HomeProfilePreview toDomain({required String fallbackId}) {
    return HomeProfilePreview(
      id: id ?? fallbackId,
      name: name ?? username ?? 'Profile',
      username: username,
      avatarUrl: avatarUrl,
      accountType: accountType,
      isVerified: isVerified,
    );
  }
}

class HomeStoryDto {
  const HomeStoryDto({
    this.id,
    this.title,
    this.imageUrl,
    this.profileName,
    this.profileAvatarUrl,
    this.items = const [],
  });

  final String? id;
  final String? title;
  final String? imageUrl;
  final String? profileName;
  final String? profileAvatarUrl;
  final List<HomeStoryItemDto> items;

  factory HomeStoryDto.fromJson(Map<String, Object?> json) {
    final profile = _mapFrom(json['profile']);
    final directTitle =
        _readString(json, const ['title', 'name']) ??
        (profile == null
            ? null
            : _readString(profile, const ['full_name', 'name', 'username']));
    final directImage = _readString(json, const [
      'image_url',
      'imageUrl',
      'cover_url',
      'media_url',
    ]);
    final itemMaps = _mapsFrom(
      _firstPresent(json, const [
        'items',
        'story_items',
        'storyItems',
        'media',
      ]),
    );

    return HomeStoryDto(
      id: _readString(json, const ['id', 'story_id']),
      title: directTitle,
      imageUrl: directImage,
      profileName: profile == null
          ? null
          : _readString(profile, const ['full_name', 'name', 'username']),
      profileAvatarUrl: profile == null
          ? null
          : _readString(profile, const ['avatar_url', 'avatarUrl']),
      items: itemMaps.map(HomeStoryItemDto.fromJson).toList(growable: false),
    );
  }

  HomeStory toDomain({required String fallbackId}) {
    return HomeStory(
      id: id ?? fallbackId,
      title: title ?? 'Story',
      imageUrl: imageUrl,
      profileName: profileName,
      profileAvatarUrl: profileAvatarUrl,
      items: [
        for (var i = 0; i < items.length; i++)
          if (items[i].title != null)
            items[i].toDomain(fallbackId: '${id ?? fallbackId}-$i'),
      ],
    );
  }
}

class HomeStoryItemDto {
  const HomeStoryItemDto({this.id, this.title, this.imageUrl});

  final String? id;
  final String? title;
  final String? imageUrl;

  factory HomeStoryItemDto.fromJson(Map<String, Object?> json) {
    return HomeStoryItemDto(
      id: _readString(json, const ['id', 'story_item_id', 'media_id']),
      title: _readString(json, const ['title', 'name', 'caption', 'text']),
      imageUrl: _readString(json, const [
        'image_url',
        'imageUrl',
        'cover_url',
        'media_url',
        'url',
      ]),
    );
  }

  HomeStoryItem toDomain({required String fallbackId}) {
    return HomeStoryItem(
      id: id ?? fallbackId,
      title: title ?? 'Story update',
      imageUrl: imageUrl,
    );
  }
}

class HomeContentDetailDto {
  const HomeContentDetailDto({
    this.id,
    required this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.badge,
    this.provider,
    this.categoryName,
    this.tags = const [],
    this.price,
    this.currency,
    this.location,
    this.promoCode,
    this.validUntil,
    this.terms,
  });

  final String? id;
  final HomeContentDetailType type;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? badge;
  final HomeContentProviderDto? provider;
  final String? categoryName;
  final List<String> tags;
  final num? price;
  final String? currency;
  final String? location;
  final String? promoCode;
  final String? validUntil;
  final String? terms;

  factory HomeContentDetailDto.fromJsonFlexible(
    Object? value, {
    required HomeContentDetailType fallbackType,
  }) {
    final source = _detailSource(value);
    if (source == null) {
      throw const FormatException(
        'Expected home detail response data to be an object.',
      );
    }

    return HomeContentDetailDto.fromJson(source, fallbackType: fallbackType);
  }

  factory HomeContentDetailDto.fromJson(
    Map<String, Object?> json, {
    required HomeContentDetailType fallbackType,
  }) {
    final profile = _mapFrom(json['profile']) ?? _mapFrom(json['provider']);
    final category = _mapFrom(json['category']);
    final mediaUrls = _readStringList(json, const [
      'media_urls',
      'mediaUrls',
      'image_urls',
      'imageUrls',
      'images',
    ]);
    final directImage = _readString(json, const [
      'image_url',
      'imageUrl',
      'media_url',
      'mediaUrl',
      'cover_url',
      'coverUrl',
      'thumbnail_url',
      'thumbnailUrl',
    ]);
    final providerId =
        _readString(json, const ['profile_id', 'provider_id']) ??
        _readString(profile, const ['id', 'profile_id']);

    return HomeContentDetailDto(
      id: _readString(json, const ['id', 'offer_id', 'ad_id']),
      type: _detailTypeFromValue(
        _readString(json, const ['type', 'kind', 'ad_type', 'content_type']),
        fallbackType,
      ),
      title: _readString(json, const ['title', 'name', 'headline']),
      description: _readString(json, const [
        'description',
        'subtitle',
        'summary',
        'body',
        'details',
      ]),
      imageUrl: directImage ?? (mediaUrls.isEmpty ? null : mediaUrls.first),
      badge: _readString(json, const [
        'badge',
        'label',
        'placement',
        'ad_type',
      ]),
      provider: profile == null
          ? providerId == null
                ? null
                : HomeContentProviderDto(id: providerId)
          : HomeContentProviderDto.fromJson(profile, fallbackId: providerId),
      categoryName:
          _readString(json, const ['category_name', 'categoryName']) ??
          _readCategoryName(category),
      tags: _readStringList(json, const ['tags', 'service_tags']),
      price: _readNum(json, const [
        'offer_price',
        'price',
        'amount',
        'discount_price',
      ]),
      currency: _readString(json, const ['currency']),
      location:
          _readString(json, const [
            'location',
            'city',
            'area',
            'full_address',
            'address',
          ]) ??
          _readString(profile, const ['location', 'city']),
      promoCode: _readString(json, const [
        'promo_code',
        'promoCode',
        'code',
        'coupon_code',
      ]),
      validUntil: _readString(json, const [
        'valid_until',
        'validUntil',
        'end_date',
        'endDate',
        'expires_at',
        'expiresAt',
      ]),
      terms: _readString(json, const ['terms', 'conditions', 'terms_text']),
    );
  }

  static List<HomeContentDetailDto> listFromJsonFlexible(
    Object? value, {
    required HomeContentDetailType fallbackType,
  }) {
    return [
      for (final map in _mapsFrom(value))
        HomeContentDetailDto.fromJson(map, fallbackType: fallbackType),
    ];
  }

  HomeContentDetail toDomain({
    required String fallbackId,
    required String fallbackCurrency,
  }) {
    return HomeContentDetail(
      id: id ?? fallbackId,
      type: type,
      title: title ?? type.dataFallbackLabel,
      description: description,
      imageUrl: imageUrl,
      badge: badge ?? type.dataFallbackLabel,
      provider: provider?.toDomain(),
      categoryName: categoryName,
      tags: tags,
      price: price == null
          ? null
          : HomeContentPrice(
              amount: price!,
              currency: _cleanCurrency(currency) ?? fallbackCurrency,
            ),
      location: location,
      promoCode: promoCode,
      validUntil: validUntil,
      terms: terms,
    );
  }
}

class HomeContentProviderDto {
  const HomeContentProviderDto({
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

  factory HomeContentProviderDto.fromJson(
    Map<String, Object?> json, {
    String? fallbackId,
  }) {
    return HomeContentProviderDto(
      id:
          _readString(json, const ['id', 'profile_id', 'provider_id']) ??
          fallbackId ??
          'provider',
      name: _readString(json, const [
        'full_name',
        'display_name',
        'name',
        'username',
      ]),
      username: _readString(json, const ['username']),
      avatarUrl: _readString(json, const ['avatar_url', 'avatarUrl']),
      accountType: _readString(json, const ['account_type', 'accountType']),
      isVerified: _readBool(json, const ['is_verified', 'isVerified']),
    );
  }

  HomeContentProvider toDomain() {
    return HomeContentProvider(
      id: id,
      name: name,
      username: username,
      avatarUrl: avatarUrl,
      accountType: accountType,
      isVerified: isVerified,
    );
  }
}

Map<String, Object?> _homeSource(Map<String, Object?> root) {
  final data = _mapFrom(root['data']);
  if (data != null && _looksLikeHomeData(data)) {
    return data;
  }

  final home = _mapFrom(root['home']);
  if (home != null) {
    return home;
  }

  final feed = _mapFrom(root['feed']);
  if (feed != null) {
    return feed;
  }

  final sections = _mapFrom(root['sections']);
  if (sections != null) {
    return sections;
  }

  return root;
}

Map<String, Object?>? _detailSource(Object? value) {
  final root = _mapFrom(value);
  if (root == null) {
    return null;
  }

  final data = _mapFrom(root['data']);
  if (data != null) {
    return _detailSource(data);
  }

  for (final key in const ['offer', 'ad', 'item', 'promotion', 'details']) {
    final nested = _mapFrom(root[key]);
    if (nested != null) {
      return nested;
    }
  }

  return root;
}

bool _looksLikeHomeData(Map<String, Object?> map) {
  const keys = [
    'stories',
    'categories',
    'featured_profiles',
    'featuredProfiles',
    'promoo_of_the_day',
    'promooOfTheDay',
    'latest_offers',
    'latestOffers',
    'services',
    'ads',
  ];

  return keys.any(map.containsKey);
}

Object? _firstPresent(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    if (map.containsKey(key)) {
      return map[key];
    }
  }
  return null;
}

List<Map<String, Object?>> _mapsFrom(Object? value) {
  final unwrapped = _unwrapListContainer(value);
  if (unwrapped is List) {
    final maps = <Map<String, Object?>>[];
    for (final item in unwrapped) {
      final mapped = _mapFrom(item);
      if (mapped != null) {
        maps.add(mapped);
      }
    }
    return maps;
  }
  return const [];
}

Object? _unwrapListContainer(Object? value) {
  if (value is List) {
    return value;
  }

  final map = _mapFrom(value);
  if (map == null) {
    return value;
  }

  for (final key in const ['data', 'items', 'results', 'list', 'records']) {
    final nested = map[key];
    if (nested is List) {
      return nested;
    }
  }

  return value;
}

Map<String, Object?>? _firstMapFrom(Object? value) {
  final maps = _mapsFrom(value);
  if (maps.isNotEmpty) {
    return maps.first;
  }
  return _mapFrom(value);
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

bool _readBool(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return false;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
  }
  return false;
}

num? _readNum(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
  }
  return null;
}

List<String> _readStringList(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is List) {
      return [
        for (final item in value)
          if (item is String && item.trim().isNotEmpty) item.trim(),
      ];
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
    }
  }
  return const [];
}

String? _readCategoryName(Map<String, Object?>? category) {
  return _readString(category, const [
    'name',
    'name_en',
    'nameEn',
    'name_ar',
    'nameAr',
    'title',
  ]);
}

HomeContentDetailType _detailTypeFromValue(
  String? value,
  HomeContentDetailType fallbackType,
) {
  final parsed = HomeContentDetailTypeValue.fromRouteValue(value);
  return parsed == HomeContentDetailType.unknown ? fallbackType : parsed;
}

String? _cleanCurrency(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value.trim().toUpperCase();
}
