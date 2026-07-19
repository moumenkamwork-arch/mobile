import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/follow_user.dart';
import '../../domain/entities/promoo_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    config: ref.watch(appConfigProvider),
    dataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.config, required this.dataSource});

  final AppConfig config;
  final ProfileDataSource dataSource;

  /// Kept as a distinct method name for interface/test stability (several
  /// widget tests implement their own [ProfileRepository] test double with
  /// this exact override) — it now just means "the signed-in user's own
  /// profile", same as [getMyProfile].
  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    try {
      final dto = await dataSource.fetchMyProfile();
      return Result.success(dto.toDomain(fallbackId: 'profile-current'));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    try {
      final dto = await dataSource.fetchProfile(idOrUsername);
      return Result.success(dto.toDomain(fallbackId: idOrUsername));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    try {
      final dto = await dataSource.fetchMyProfile();
      return Result.success(dto.toDomain(fallbackId: 'me'));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(
    String profileId,
  ) async {
    try {
      final dto = await dataSource.fetchProfilePackages(profileId);
      return Result.success(
        dto.toDomain(
          fallbackCurrency: config.fallbackCurrency,
          profileId: profileId,
        ),
      );
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(
    ProfileUpdateDraft draft,
  ) async {
    try {
      final dto = await dataSource.updateMyProfile(draft);
      return Result.success(dto.toDomain(fallbackId: 'me'));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<bool>> getFollowStatus(String profileId) async {
    try {
      return Result.success(await dataSource.fetchFollowStatus(profileId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> followProfile(String profileId) async {
    try {
      await dataSource.followProfile(profileId);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> unfollowProfile(String profileId) async {
    try {
      await dataSource.unfollowProfile(profileId);
      return const Result.success(null);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<FollowUser>>> getFollowing(String profileId) async {
    try {
      return Result.success(await dataSource.fetchFollowing(profileId));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
