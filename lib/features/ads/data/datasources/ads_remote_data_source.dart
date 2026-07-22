import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/ad_draft.dart';
import '../../domain/entities/ad_listing.dart';
import '../dto/ad_listing_dto.dart';

final adsRemoteDataSourceProvider = Provider<AdsRemoteDataSource>((ref) {
  return AdsRemoteDataSource(ref.watch(apiClientProvider));
});

class AdsRemoteDataSource {
  const AdsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Builds the `createAdSchema`/`updateAdSchema` payload — required fields
  /// always present, optionals omitted when empty (rather than sent as
  /// null/"") so the schema's `.optional()`/`.email()`/`.url()` refinements
  /// don't reject blanks.
  Map<String, Object?> _body(AdDraft draft) {
    return <String, Object?>{
      'title': draft.title,
      'media_url': draft.mediaUrl,
      'ad_type': draft.adType,
      'budget': draft.budget,
      'start_date': draft.startDate.toUtc().toIso8601String(),
      'tags': draft.tags,
      if (_has(draft.description)) 'description': draft.description,
      if (draft.endDate != null)
        'end_date': draft.endDate!.toUtc().toIso8601String(),
      if (_has(draft.phone)) 'phone': draft.phone,
      if (_has(draft.whatsapp)) 'whatsapp': draft.whatsapp,
      if (_has(draft.contactEmail)) 'contact_email': draft.contactEmail,
      if (_has(draft.instagramLink)) 'instagram_link': draft.instagramLink,
      if (_has(draft.city)) 'city': draft.city,
      if (_has(draft.area)) 'area': draft.area,
      if (_has(draft.fullAddress)) 'full_address': draft.fullAddress,
      if (_has(draft.locationMapUrl)) 'location_map_url': draft.locationMapUrl,
      if (draft.price != null) 'price': draft.price,
      if (_has(draft.currency)) 'currency': draft.currency,
      if (_has(draft.serviceType)) 'service_type': draft.serviceType,
      if (_has(draft.paymentMethod)) 'payment_method': draft.paymentMethod,
    };
  }

  Future<String> createAd(AdDraft draft) async {
    final response = await _apiClient.post<String>(
      ApiEndpoints.ads,
      data: _body(draft),
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : const {};
        return (map['id'] as String?) ?? '';
      },
    );
    return response.data ?? '';
  }

  Future<void> updateAd(String id, AdDraft draft) async {
    await _apiClient.put<void>(
      ApiEndpoints.adById(id),
      data: _body(draft),
      decode: (_) {},
    );
  }

  Future<void> deleteAd(String id) async {
    await _apiClient.delete<void>(ApiEndpoints.adById(id), decode: (_) {});
  }

  Future<List<AdListing>> getMyAds(String profileId) async {
    final response = await _apiClient.get<List<AdListing>>(
      ApiEndpoints.adsByProfile(profileId),
      decode: parseAdListings,
    );
    return response.data ?? const [];
  }

  static bool _has(String? value) => value != null && value.trim().isNotEmpty;
}
