import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/services_dto.dart';
import 'services_data_source.dart';

final servicesFakeDataSourceProvider = Provider<ServicesFakeDataSource>((ref) {
  return const ServicesFakeDataSource();
});

class ServicesFakeDataSource implements ServicesDataSource {
  const ServicesFakeDataSource();

  static const _categories = [
    ServiceCategoryDto(
      id: 'cat-beauty-wellness',
      name: 'Beauty & Wellness',
      slug: 'beauty-wellness',
    ),
    ServiceCategoryDto(
      id: 'cat-restaurants-cafes',
      name: 'Restaurants & Cafes',
      slug: 'restaurants-cafes',
    ),
    ServiceCategoryDto(
      id: 'cat-events-photography',
      name: 'Events & Photography',
      slug: 'events-photography',
    ),
    ServiceCategoryDto(
      id: 'cat-fashion-styling',
      name: 'Fashion & Styling',
      slug: 'fashion-styling',
    ),
    ServiceCategoryDto(
      id: 'cat-health-fitness',
      name: 'Health & Fitness',
      slug: 'health-fitness',
    ),
    ServiceCategoryDto(
      id: 'cat-home-lifestyle',
      name: 'Home & Lifestyle',
      slug: 'home-lifestyle',
    ),
    ServiceCategoryDto(
      id: 'cat-digital-marketing',
      name: 'Digital Marketing',
      slug: 'digital-marketing',
    ),
    ServiceCategoryDto(
      id: 'cat-influencer-campaigns',
      name: 'Influencer Campaigns',
      slug: 'influencer-campaigns',
    ),
  ];

  static const _services = [
    PromooServiceDto(
      id: 'service-influencer-launch',
      title: 'Boutique influencer launch package',
      description:
          'A curated creator campaign with story coverage, reels guidance, and provider coordination for a polished launch.',
      category: ServiceCategoryDto(
        id: 'cat-influencer-campaigns',
        name: 'Influencer Campaigns',
      ),
      provider: ServiceProviderDto(
        id: 'profile-saffron-social',
        name: 'Saffron Social Studio',
        username: 'saffron.social',
        accountType: 'company',
        isVerified: true,
      ),
      price: 2200,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 5,
      tags: ['Campaign', 'Reels', 'Stories'],
    ),
    PromooServiceDto(
      id: 'service-product-photography',
      title: 'Product photography session',
      description:
          'Editorial product photography for marketplace listings, launch posts, and profile media.',
      category: ServiceCategoryDto(
        id: 'cat-events-photography',
        name: 'Events & Photography',
      ),
      provider: ServiceProviderDto(
        id: 'profile-framehouse',
        name: 'Framehouse Events',
        username: 'framehouse.events',
        accountType: 'service_provider',
        isVerified: true,
      ),
      price: 1450,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 3,
      tags: ['Photography', 'Product'],
    ),
    PromooServiceDto(
      id: 'service-salon-launch',
      title: 'Salon launch promotion',
      description:
          'A premium launch push for beauty and wellness providers with short-form content and profile placement.',
      category: ServiceCategoryDto(
        id: 'cat-beauty-wellness',
        name: 'Beauty & Wellness',
      ),
      provider: ServiceProviderDto(
        id: 'profile-velvet-beauty',
        name: 'Velvet Beauty Lounge',
        username: 'velvet.beauty',
        accountType: 'service_provider',
        isVerified: true,
      ),
      price: 1800,
      currency: 'AED',
      location: 'Abu Dhabi',
      deliveryDays: 4,
      tags: ['Beauty', 'Launch'],
    ),
    PromooServiceDto(
      id: 'service-cafe-opening',
      title: 'Cafe opening campaign',
      description:
          'A launch campaign for new cafe openings with visual storytelling and discovery-focused content.',
      category: ServiceCategoryDto(
        id: 'cat-restaurants-cafes',
        name: 'Restaurants & Cafes',
      ),
      provider: ServiceProviderDto(
        id: 'profile-pearl-cafe',
        name: 'Pearl District Cafe',
        username: 'pearl.district',
        accountType: 'company',
        isVerified: true,
      ),
      price: 2500,
      currency: 'AED',
      location: 'Sharjah',
      deliveryDays: 6,
      tags: ['Cafe', 'Opening'],
    ),
    PromooServiceDto(
      id: 'service-wellness-awareness',
      title: 'Wellness awareness package',
      description:
          'A calm awareness campaign for wellness centers, boutique gyms, and lifestyle providers.',
      category: ServiceCategoryDto(
        id: 'cat-health-fitness',
        name: 'Health & Fitness',
      ),
      provider: ServiceProviderDto(
        id: 'profile-calmfit',
        name: 'CalmFit Wellness',
        username: 'calmfit.wellness',
        accountType: 'company',
      ),
      price: 1600,
      currency: 'AED',
      location: 'Abu Dhabi',
      deliveryDays: 5,
      tags: ['Wellness', 'Awareness'],
    ),
    PromooServiceDto(
      id: 'service-fashion-styling',
      title: 'Seasonal styling content pack',
      description:
          'Fashion styling content for seasonal collections, creator shoots, and premium profile updates.',
      category: ServiceCategoryDto(
        id: 'cat-fashion-styling',
        name: 'Fashion & Styling',
      ),
      provider: ServiceProviderDto(
        id: 'profile-orchid-style',
        name: 'Orchid Styling Co.',
        username: 'orchid.style',
        accountType: 'service_provider',
      ),
      price: 1950,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 4,
      tags: ['Styling', 'Content'],
    ),
    PromooServiceDto(
      id: 'service-home-lifestyle',
      title: 'Home lifestyle shoot',
      description:
          'Warm lifestyle visuals for interiors, home accessories, and premium product presentations.',
      category: ServiceCategoryDto(
        id: 'cat-home-lifestyle',
        name: 'Home & Lifestyle',
      ),
      provider: ServiceProviderDto(
        id: 'profile-vista-home',
        name: 'Vista Home Living',
        username: 'vista.home',
        accountType: 'company',
      ),
      price: 1750,
      currency: 'AED',
      location: 'Ajman',
      deliveryDays: 4,
      tags: ['Lifestyle', 'Interiors'],
    ),
    PromooServiceDto(
      id: 'service-ads-strategy',
      title: 'Launch ads strategy sprint',
      description:
          'A focused digital marketing sprint for launch positioning, creative angles, and campaign setup guidance.',
      category: ServiceCategoryDto(
        id: 'cat-digital-marketing',
        name: 'Digital Marketing',
      ),
      provider: ServiceProviderDto(
        id: 'profile-saffron-social',
        name: 'Saffron Social Studio',
        username: 'saffron.social',
        accountType: 'company',
        isVerified: true,
      ),
      price: 2800,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 7,
      tags: ['Strategy', 'Campaign'],
    ),
  ];

  @override
  Future<ServiceCategoriesDto> fetchCategories() async {
    return const ServiceCategoriesDto(_categories);
  }

  @override
  Future<PromooServicesDto> fetchServices({
    String? categoryId,
    String? query,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase();
    final services = _services
        .where((service) {
          final categoryMatches =
              categoryId == null ||
              categoryId.isEmpty ||
              service.category?.id == categoryId;
          final queryMatches =
              normalizedQuery == null ||
              normalizedQuery.isEmpty ||
              (service.title ?? '').toLowerCase().contains(normalizedQuery) ||
              (service.description ?? '').toLowerCase().contains(
                normalizedQuery,
              ) ||
              (service.category?.name ?? '').toLowerCase().contains(
                normalizedQuery,
              ) ||
              (service.provider?.name ?? '').toLowerCase().contains(
                normalizedQuery,
              ) ||
              service.tags.any(
                (tag) => tag.toLowerCase().contains(normalizedQuery),
              );
          return categoryMatches && queryMatches;
        })
        .toList(growable: false);

    return PromooServicesDto(services);
  }

  @override
  Future<PromooServiceDto> fetchServiceById(String id) async {
    return _services.firstWhere(
      (service) => service.id == id,
      orElse: () => throw const FormatException('Service not found.'),
    );
  }
}
