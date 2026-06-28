import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/features/profile/presentation/controllers/profile_controller.dart';

void main() {
  test('emits loading then success for demo profile', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ProfileRepository(
            profileResult: Result.success(_profile),
            packagesResult: Result.success([_package]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(profileControllerProvider).status,
      ProfileStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileControllerProvider);
    expect(state.status, ProfileStatus.success);
    expect(state.profile?.displayName, 'Saffron Social Studio');
    expect(state.packages.single.title, 'Boutique launch campaign');
  });

  test('uses target provider for public profile route', () async {
    final repository = _ProfileRepository(
      profileResult: const Result.success(_profile),
      packagesResult: const Result.success([_package]),
    );
    final container = ProviderContainer(
      overrides: [
        profileTargetProvider.overrideWithValue('saffron.social'),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(repository.lastProfileTarget, 'saffron.social');
    expect(
      container.read(profileControllerProvider).status,
      ProfileStatus.success,
    );
  });

  test('emits empty when profile is not found', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ProfileRepository(
            profileResult: Result.failure(
              AppFailure.notFound(message: 'Not found'),
            ),
            packagesResult: Result.success([]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileControllerProvider);
    expect(state.status, ProfileStatus.empty);
    expect(state.failure?.message, 'Not found');
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ProfileRepository(
            profileResult: Result.failure(
              AppFailure.network(message: 'No connection'),
            ),
            packagesResult: Result.success([]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileControllerProvider);
    expect(state.status, ProfileStatus.error);
    expect(state.failure?.message, 'No connection');
  });

  test('sets safe action states', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ProfileRepository(
            profileResult: Result.success(_profile),
            packagesResult: Result.success([]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    container.read(profileControllerProvider.notifier).requestFollow();
    expect(
      container.read(profileControllerProvider).actionStatus,
      ProfileActionStatus.followAuthRequired,
    );

    container.read(profileControllerProvider.notifier).requestMessage();
    expect(
      container.read(profileControllerProvider).actionStatus,
      ProfileActionStatus.messageComingSoon,
    );
  });
}

const _profile = PromooProfile(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
  username: 'saffron.social',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(followers: 185400, following: 124, services: 1),
  isVerified: true,
);

const _package = ProfilePackage(
  id: 'package-1',
  title: 'Boutique launch campaign',
  price: ProfilePackagePrice(amount: 2200, currency: 'AED'),
);

class _ProfileRepository implements ProfileRepository {
  const _ProfileRepository({
    required this.profileResult,
    required this.packagesResult,
  });

  final Result<PromooProfile> profileResult;
  final Result<List<ProfilePackage>> packagesResult;
  static const Result<PromooProfile> editResult = Result.failure(
    AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
  );

  String? get lastProfileTarget => _lastProfileTarget;
  static String? _lastProfileTarget;

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    _lastProfileTarget = idOrUsername;
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    return profileResult;
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(
    String profileId,
  ) async {
    return packagesResult;
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(
    ProfileUpdateDraft draft,
  ) async {
    return editResult;
  }
}
