import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/promoo_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';
import '../datasources/profile_fake_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    fakeDataSource: ref.watch(profileFakeDataSourceProvider),
  );
});

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final AppConfig config;
  final ProfileDataSource remoteDataSource;
  final ProfileFakeDataSource fakeDataSource;

  ProfileDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    try {
      final dto = await fakeDataSource.fetchDemoProfile();
      return Result.success(dto.toDomain(fallbackId: 'profile-demo'));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    try {
      final dto = await _activeDataSource.fetchProfile(idOrUsername);
      return Result.success(dto.toDomain(fallbackId: idOrUsername));
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    try {
      final dto = await _activeDataSource.fetchMyProfile();
      return Result.success(dto.toDomain(fallbackId: 'me'));
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
      final dto = await _activeDataSource.fetchProfilePackages(profileId);
      return Result.success(
        dto.toDomain(
          fallbackCurrency: config.fallbackCurrency,
          profileId: profileId,
        ),
      );
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
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
    return const Result.failure(
      AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
    );
  }
}
