import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/ad_draft.dart';
import '../../domain/entities/ad_listing.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_data_source.dart';

final adsRepositoryProvider = Provider<AdsRepository>((ref) {
  return AdsRepositoryImpl(ref.watch(adsRemoteDataSourceProvider));
});

class AdsRepositoryImpl implements AdsRepository {
  const AdsRepositoryImpl(this._dataSource);

  final AdsRemoteDataSource _dataSource;

  @override
  Future<Result<String>> createAd(AdDraft draft) async {
    try {
      return Result.success(await _dataSource.createAd(draft));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> updateAd(String id, AdDraft draft) async {
    try {
      await _dataSource.updateAd(id, draft);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> deleteAd(String id) async {
    try {
      await _dataSource.deleteAd(id);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<AdListing>>> getMyAds(String profileId) async {
    try {
      return Result.success(await _dataSource.getMyAds(profileId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
