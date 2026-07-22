import '../../../../core/utils/result.dart';
import '../entities/ad_draft.dart';
import '../entities/ad_listing.dart';

abstract interface class AdsRepository {
  /// `POST /ads` (role-gated to company/influencer). The ad is created with
  /// `status: pending` server-side, awaiting admin activation. Returns the new
  /// ad's id on success.
  Future<Result<String>> createAd(AdDraft draft);

  /// `GET /ads/profile/:id` (owner-only server-side — 403 otherwise).
  Future<Result<List<AdListing>>> getMyAds(String profileId);

  /// `PUT /ads/:id` (ownership-checked server-side).
  Future<Result<void>> updateAd(String id, AdDraft draft);

  /// `DELETE /ads/:id` (ownership-checked server-side).
  Future<Result<void>> deleteAd(String id);
}
