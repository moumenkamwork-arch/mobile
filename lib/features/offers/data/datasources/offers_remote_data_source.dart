import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/offer_draft.dart';
import '../../domain/entities/offer_listing.dart';
import '../dto/offer_listing_dto.dart';

final offersRemoteDataSourceProvider = Provider<OffersRemoteDataSource>((ref) {
  return OffersRemoteDataSource(ref.watch(apiClientProvider));
});

class OffersRemoteDataSource {
  const OffersRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Builds the `createOfferSchema`/`updateOfferSchema` payload (identical
  /// field set). Dates go as ISO-8601 UTC (`.datetime()` on the backend);
  /// optional numeric fields are omitted when null rather than sent as null,
  /// matching the schema's `.optional()`.
  Map<String, Object?> _body(OfferDraft draft) {
    return <String, Object?>{
      'category_id': draft.categoryId,
      'title': draft.title,
      'description': draft.description,
      'offer_price': draft.offerPrice,
      'start_date': draft.startDate.toUtc().toIso8601String(),
      'media_urls': draft.mediaUrls,
      'tags': draft.tags,
      if (draft.originalPrice != null) 'original_price': draft.originalPrice,
      if (draft.discountPercentage != null)
        'discount_percentage': draft.discountPercentage,
      if (draft.endDate != null)
        'end_date': draft.endDate!.toUtc().toIso8601String(),
    };
  }

  Future<String> createOffer(OfferDraft draft) async {
    final response = await _apiClient.post<String>(
      ApiEndpoints.offers,
      data: _body(draft),
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : const {};
        return (map['id'] as String?) ?? '';
      },
    );
    return response.data ?? '';
  }

  Future<void> updateOffer(String id, OfferDraft draft) async {
    await _apiClient.put<void>(
      ApiEndpoints.offerById(id),
      data: _body(draft),
      decode: (_) {},
    );
  }

  Future<void> deleteOffer(String id) async {
    await _apiClient.delete<void>(ApiEndpoints.offerById(id), decode: (_) {});
  }

  Future<List<OfferListing>> getMyOffers(String profileId) async {
    final response = await _apiClient.get<List<OfferListing>>(
      ApiEndpoints.offersByProfile(profileId),
      decode: parseOfferListings,
    );
    return response.data ?? const [];
  }
}
