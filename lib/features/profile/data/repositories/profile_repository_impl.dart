import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/promoo_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_fake_data_source.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    config: ref.watch(appConfigProvider),
    dataSource: ref.watch(profileFakeDataSourceProvider),
  );
});

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.config, required this.dataSource});

  final AppConfig config;
  final ProfileFakeDataSource dataSource;

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    try {
      final dto = await dataSource.fetchDemoProfile();
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
    // Frontend-only: profile edits are local UI until integration is wired.
    return const Result.failure(
      AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
    );
  }
}
