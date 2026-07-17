import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/saved_dto.dart';
import 'saved_data_source.dart';

final savedFakeDataSourceProvider = Provider<SavedFakeDataSource>((ref) {
  return SavedFakeDataSource();
});

/// In-memory saved list for tests / offline demo. Mirrors the enriched
/// `GET /saved` shape (`{id, item_type, item:{...}}`).
class SavedFakeDataSource implements SavedDataSource {
  SavedFakeDataSource();

  final List<Map<String, Object?>> _rows = [
    {
      'id': 'saved-1',
      'item_id': 'offer-1',
      'item_type': 'offer',
      'item': {
        'id': 'offer-1',
        'title': 'Cafe opening spotlight',
        'offer_price': 149,
        'media_urls': [
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=640&q=80',
        ],
      },
    },
  ];

  @override
  Future<SavedItemsDto> fetchSaved() async {
    return SavedItemsDto.fromJsonFlexible(_rows);
  }

  @override
  Future<void> removeSaved(String savedId) async {
    _rows.removeWhere((row) => row['id'] == savedId);
  }
}
