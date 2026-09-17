import '../../../../core/utils/result.dart';
import '../entities/offer_draft.dart';
import '../entities/offer_listing.dart';

abstract interface class OffersRepository {
  /// `POST /offers` (role-gated to company/service_provider by the backend —
  /// the UI already hides the entry point for other account types via
  /// `accountCapabilities`). Returns the new offer's id on success.
  Future<Result<String>> createOffer(OfferDraft draft);

  /// `GET /offers/profile/:id`. Pass the signed-in user's own id — the
  /// backend returns every status (draft/active/expired/rejected) only to
  /// the owner, same shape as the public feed otherwise.
  Future<Result<List<OfferListing>>> getMyOffers(String profileId);

  /// `PUT /offers/:id` (ownership-checked server-side).
  Future<Result<void>> updateOffer(String id, OfferDraft draft);

  /// `DELETE /offers/:id` (ownership-checked server-side).
  Future<Result<void>> deleteOffer(String id);
}
