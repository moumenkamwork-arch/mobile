import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/offer_draft.dart';
import '../../domain/entities/offer_listing.dart';
import '../../domain/repositories/offers_repository.dart';
import '../datasources/offers_remote_data_source.dart';

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepositoryImpl(ref.watch(offersRemoteDataSourceProvider));
});

class OffersRepositoryImpl implements OffersRepository {
  const OffersRepositoryImpl(this._dataSource);

  final OffersRemoteDataSource _dataSource;

  @override
  Future<Result<String>> createOffer(OfferDraft draft) async {
    try {
      return Result.success(await _dataSource.createOffer(draft));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> updateOffer(String id, OfferDraft draft) async {
    try {
      await _dataSource.updateOffer(id, draft);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> deleteOffer(String id) async {
    try {
      await _dataSource.deleteOffer(id);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<OfferListing>>> getMyOffers(String profileId) async {
    try {
      return Result.success(await _dataSource.getMyOffers(profileId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
