import '../../domain/entities/saved_item.dart';

/// Parses a `GET /saved` row: `{ id, item_id, item_type, item: {...} }` where
/// `item` is the polymorphic hydrated offer/service/ad/profile (backend already
/// joins it — see `saved.service.ts`). Reads defensively so any of those shapes
/// map to a common card.
class SavedItemDto {
  const SavedItemDto({
    this.id,
    this.itemId,
    this.itemType,
    this.item,
  });

  final String? id;
  final String? itemId;
  final String? itemType;
  final Map<String, Object?>? item;

  factory SavedItemDto.fromJson(Map<String, Object?> json) {
    return SavedItemDto(
      id: _string(json, const ['id', 'saved_id', 'savedId']),
      itemId: _string(json, const ['item_id', 'itemId']),
      itemType: _string(json, const ['item_type', 'itemType']),
      item: _map(json['item']),
    );
  }

  bool get hasIdentity => id != null && item != null;

  SavedItem? toDomain() {
    final rowId = id;
    final data = item;
    if (rowId == null || data == null) {
      return null;
    }

    final title =
        _string(data, const ['title', 'full_name', 'fullName', 'name']) ??
        'Saved item';
    final image = _string(data, const [
      'media_url',
      'avatar_url',
      'avatarUrl',
    ]) ?? _firstMediaUrl(data['media_urls']);

    return SavedItem(
      id: rowId,
      itemId: itemId ?? _string(data, const ['id']) ?? rowId,
      itemType: itemType ?? 'item',
      title: title,
      subtitle: _subtitleFor(data),
      imageUrl: image,
    );
  }

  static String? _subtitleFor(Map<String, Object?> data) {
    final username = _string(data, const ['username']);
    if (username != null) return '@$username';
    final price = _num(data, const ['offer_price', 'price', 'amount']);
    if (price != null) return '${price % 1 == 0 ? price.toInt() : price} AED';
    return _string(data, const ['description', 'bio']);
  }
}

class SavedItemsDto {
  const SavedItemsDto(this.items);

  final List<SavedItemDto> items;

  factory SavedItemsDto.empty() => const SavedItemsDto([]);

  factory SavedItemsDto.fromJsonFlexible(Object? value) {
    return SavedItemsDto(
      _list(value).map(SavedItemDto.fromJson).toList(growable: false),
    );
  }

  List<SavedItem> toDomain() {
    final result = <SavedItem>[];
    for (final dto in items) {
      final domain = dto.toDomain();
      if (domain != null) result.add(domain);
    }
    return result;
  }
}

List<Map<String, Object?>> _list(Object? value) {
  final raw = value is List
      ? value
      : (value is Map ? value['data'] ?? value['items'] : null);
  if (raw is! List) return const [];
  final maps = <Map<String, Object?>>[];
  for (final item in raw) {
    final m = _map(item);
    if (m != null) maps.add(m);
  }
  return maps;
}

Map<String, Object?>? _map(Object? value) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) return Map<String, Object?>.from(value);
  return null;
}

String? _firstMediaUrl(Object? value) {
  if (value is List && value.isNotEmpty) {
    final first = value.first;
    if (first is String && first.trim().isNotEmpty) return first.trim();
  }
  return null;
}

String? _string(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

num? _num(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return null;
}
