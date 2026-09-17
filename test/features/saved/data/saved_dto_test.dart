import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/saved/data/dto/saved_dto.dart';

/// Locks the polymorphic `GET /saved` parsing: each row is `{id, item_type,
/// item:{...}}` where `item` is a hydrated offer / service / ad / profile.
void main() {
  test('maps an offer row (title, price subtitle, first media url)', () {
    final items = SavedItemsDto.fromJsonFlexible([
      {
        'id': 'saved-1',
        'item_id': 'offer-1',
        'item_type': 'offer',
        'item': {
          'id': 'offer-1',
          'title': 'Cafe spotlight',
          'offer_price': 149,
          'media_urls': ['https://img/one.jpg', 'https://img/two.jpg'],
        },
      },
    ]).toDomain();

    expect(items.length, 1);
    final offer = items.single;
    expect(offer.id, 'saved-1'); // saved-row id (used for DELETE /saved/:id)
    expect(offer.itemId, 'offer-1');
    expect(offer.itemType, 'offer');
    expect(offer.title, 'Cafe spotlight');
    expect(offer.subtitle, '149 AED');
    expect(offer.imageUrl, 'https://img/one.jpg');
  });

  test('maps a profile row (full_name title, @username subtitle, avatar)', () {
    final items = SavedItemsDto.fromJsonFlexible([
      {
        'id': 'saved-2',
        'item_id': 'p-1',
        'item_type': 'profile',
        'item': {
          'id': 'p-1',
          'full_name': 'Saffron Studio',
          'username': 'saffron',
          'avatar_url': 'https://img/avatar.jpg',
        },
      },
    ]).toDomain();

    final profile = items.single;
    expect(profile.title, 'Saffron Studio');
    expect(profile.subtitle, '@saffron');
    expect(profile.imageUrl, 'https://img/avatar.jpg');
  });

  test('drops rows with no hydrated item', () {
    final items = SavedItemsDto.fromJsonFlexible([
      {'id': 'saved-3', 'item_id': 'gone', 'item_type': 'offer', 'item': null},
    ]).toDomain();

    expect(items, isEmpty);
  });

  test('reads a nested {data:[...]} envelope', () {
    final items = SavedItemsDto.fromJsonFlexible({
      'data': [
        {
          'id': 's',
          'item_type': 'service',
          'item': {'id': 'x', 'title': 'Shoot', 'price': 99},
        },
      ],
    }).toDomain();

    expect(items.single.title, 'Shoot');
    expect(items.single.subtitle, '99 AED');
  });
}
