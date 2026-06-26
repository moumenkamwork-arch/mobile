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
      id: 'cat-marketing',
      name: 'Marketing',
      slug: 'marketing',
    ),
    ServiceCategoryDto(id: 'cat-events', name: 'Events', slug: 'events'),
    ServiceCategoryDto(id: 'cat-beauty', name: 'Beauty', slug: 'beauty'),
    ServiceCategoryDto(id: 'cat-food', name: 'Food', slug: 'food'),
  ];

  static const _services = [
    PromooServiceDto(
      id: 'service-content',
      title: 'Premium content package',
      description: 'Short-form social content for marketplace campaigns.',
      category: ServiceCategoryDto(id: 'cat-marketing', name: 'Marketing'),
      provider: ServiceProviderDto(
        id: 'profile-demo',
        name: 'Noura Studio',
        username: 'noura.studio',
        accountType: 'service_provider',
        isVerified: true,
      ),
      price: 750,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 5,
      tags: ['Content', 'Video'],
    ),
    PromooServiceDto(
      id: 'service-events',
      title: 'Event coverage',
      description: 'Photo and video coverage for launches and private events.',
      category: ServiceCategoryDto(id: 'cat-events', name: 'Events'),
      provider: ServiceProviderDto(
        id: 'provider-lens',
        name: 'Lens Partner',
        username: 'lens.partner',
        accountType: 'company',
      ),
      price: 1200,
      currency: 'AED',
      location: 'Dubai',
      deliveryDays: 3,
      tags: ['Photo', 'Video'],
    ),
    PromooServiceDto(
      id: 'service-menu',
      title: 'Restaurant launch reel',
      description: 'A polished reel for new menu or branch announcements.',
      category: ServiceCategoryDto(id: 'cat-food', name: 'Food'),
      provider: ServiceProviderDto(
        id: 'provider-table',
        name: 'Table Media',
        username: 'table.media',
        accountType: 'company',
      ),
      price: 900,
      currency: 'AED',
      location: 'Abu Dhabi',
      tags: ['Food', 'Reels'],
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
