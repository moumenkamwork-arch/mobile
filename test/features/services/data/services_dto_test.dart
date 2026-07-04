import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/services/data/dto/services_dto.dart';

void main() {
  test('parses categories fixture defensively', () {
    final dto = ServiceCategoriesDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'cat-1',
          'name_ar': 'تسويق',
          'name_en': 'Marketing',
          'slug': 'marketing',
          'image_url': 'https://example.com/category.jpg',
        },
      ],
    });

    final categories = dto.toDomain();

    expect(categories.single.id, 'cat-1');
    expect(categories.single.name, 'Marketing');
    expect(categories.single.nameAr, 'تسويق');
    expect(categories.single.slug, 'marketing');
    expect(categories.single.imageUrl, 'https://example.com/category.jpg');
  });

  test('parses services list and falls back to configured currency', () {
    final dto = PromooServicesDto.fromJsonFlexible({
      'data': [
        {
          'id': 'service-1',
          'title': 'Event coverage',
          'description': 'Photo and video coverage.',
          'price': 1200,
          'profile': {
            'id': 'profile-framehouse',
            'full_name': 'Framehouse Events',
            'is_verified': true,
          },
          'category': {'id': 'cat-events', 'name_en': 'Events'},
          'delivery_days': 3,
          'tags': ['Photo', 'Video'],
        },
      ],
    });

    final services = dto.toDomain(fallbackCurrency: 'SAR');

    expect(services.single.title, 'Event coverage');
    expect(services.single.price?.label, '1200 SAR');
    expect(services.single.provider?.name, 'Framehouse Events');
    expect(services.single.provider?.isVerified, isTrue);
    expect(services.single.category?.name, 'Events');
    expect(services.single.deliveryDays, 3);
    expect(services.single.tags, ['Photo', 'Video']);
  });

  test('parses service detail object', () {
    final dto = PromooServicesDto.fromJsonFlexible({
      'success': true,
      'data': {
        'id': 'service-2',
        'title': 'Restaurant launch reel',
        'price': '900.50',
        'currency': 'aed',
        'location': 'Dubai',
        'media_urls': ['https://example.com/service.jpg'],
      },
    });

    final service = dto.toDomain(fallbackCurrency: 'SAR').single;

    expect(service.id, 'service-2');
    expect(service.price?.label, '900.50 AED');
    expect(service.location, 'Dubai');
    expect(service.imageUrls.single, 'https://example.com/service.jpg');
  });
}
