import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/profile/data/datasources/profile_data_source.dart';
import 'package:promoo_app/features/profile/data/datasources/profile_fake_data_source.dart';
import 'package:promoo_app/features/profile/data/dto/profile_dto.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';

void main() {
  test('fake profile packages use AED for demo prices', () async {
    final repository = ProfileRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: const ProfileFakeDataSource(),
    );

    final result = await repository.getProfilePackages(
      ProfileFakeDataSource.demoProfileId,
    );

    expect(result.isSuccess, isTrue);
    result.when(
      success: (packages) {
        expect(packages, isNotEmpty);
        expect(
          packages.map((package) => package.price?.currency),
          everyElement('AED'),
        );
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('returns demo profile from fake data source', () async {
    final repository = ProfileRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: const ProfileFakeDataSource(),
    );

    final result = await repository.getDemoProfile();

    expect(result.isSuccess, isTrue);
    result.when(
      success: (profile) {
        expect(profile.id, ProfileFakeDataSource.demoProfileId);
        expect(profile.displayName, 'Saffron Social Studio');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      profile: const PromooProfileDto(
        id: 'profile-remote',
        displayName: 'Remote Profile',
        accountType: 'service_provider',
      ),
      packages: const ProfilePackagesDto([
        ProfilePackageDto(
          id: 'package-remote',
          profileId: 'profile-remote',
          title: 'Remote package',
          price: 500,
          currency: 'AED',
        ),
      ]),
    );
    final repository = ProfileRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: const ProfileFakeDataSource(),
    );

    final profileResult = await repository.getProfile('profile-remote');
    final packagesResult = await repository.getProfilePackages(
      'profile-remote',
    );

    expect(remoteDataSource.lastProfileTarget, 'profile-remote');
    expect(remoteDataSource.lastPackagesProfileId, 'profile-remote');
    profileResult.when(
      success: (profile) {
        expect(profile.accountType, ProfileAccountType.serviceProvider);
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
    packagesResult.when(
      success: (packages) => expect(packages.single.title, 'Remote package'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('maps API exceptions to failures', () async {
    final repository = ProfileRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.notFound,
          message: 'Profile not found',
        ),
      ),
      fakeDataSource: const ProfileFakeDataSource(),
    );

    final result = await repository.getProfile('missing');

    expect(result.isFailure, isTrue);
    result.when(
      success: (profile) => fail('Expected failure, got $profile'),
      failure: (failure) => expect(failure.message, 'Profile not found'),
    );
  });

  test('returns auth-required failure for edit placeholder', () async {
    final repository = ProfileRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: const ProfileFakeDataSource(),
    );

    final result = await repository.updateMyProfile(
      const ProfileUpdateDraft(displayName: 'Updated'),
    );

    expect(result.isFailure, isTrue);
    result.when(
      success: (profile) => fail('Expected failure, got $profile'),
      failure: (failure) =>
          expect(failure.message, 'Sign in to edit your profile.'),
    );
  });
}

class _RecordingDataSource implements ProfileDataSource {
  _RecordingDataSource({required this.profile, required this.packages});

  final PromooProfileDto profile;
  final ProfilePackagesDto packages;
  String? lastProfileTarget;
  String? lastPackagesProfileId;

  @override
  Future<PromooProfileDto> fetchProfile(String idOrUsername) async {
    lastProfileTarget = idOrUsername;
    return profile;
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() async {
    return profile;
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) async {
    lastPackagesProfileId = profileId;
    return packages;
  }
}

class _ThrowingDataSource implements ProfileDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<PromooProfileDto> fetchProfile(String idOrUsername) {
    return Future<PromooProfileDto>.error(error);
  }

  @override
  Future<PromooProfileDto> fetchMyProfile() {
    return Future<PromooProfileDto>.error(error);
  }

  @override
  Future<ProfilePackagesDto> fetchProfilePackages(String profileId) {
    return Future<ProfilePackagesDto>.error(error);
  }
}
