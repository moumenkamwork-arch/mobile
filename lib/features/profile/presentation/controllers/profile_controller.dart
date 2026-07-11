import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/promoo_profile.dart';

// `profileTargetProvider` carries the route's profile id/username. ProfileScreen
// overrides it in a nested ProviderScope AND re-creates this controller in that
// same scope (`profileControllerProvider.overrideWith(...)`) so the controller
// actually reads the scoped target — a root-scoped controller would ignore the
// nested override and always load the demo profile.
final profileTargetProvider = Provider<String?>((ref) => null);

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);

enum ProfileStatus { loading, success, empty, error, refreshing }

class ProfileState {
  const ProfileState({
    required this.status,
    this.profile,
    this.packages = const [],
    this.failure,
    this.isFollowing = false,
  });

  const ProfileState.loading() : this(status: ProfileStatus.loading);

  const ProfileState.success({
    required PromooProfile profile,
    List<ProfilePackage> packages = const [],
    bool isFollowing = false,
  }) : this(
         status: ProfileStatus.success,
         profile: profile,
         packages: packages,
         isFollowing: isFollowing,
       );

  const ProfileState.empty({AppFailure? failure})
    : this(status: ProfileStatus.empty, failure: failure);

  const ProfileState.error({
    required AppFailure failure,
    PromooProfile? profile,
    List<ProfilePackage> packages = const [],
  }) : this(
         status: ProfileStatus.error,
         failure: failure,
         profile: profile,
         packages: packages,
       );

  const ProfileState.refreshing({
    PromooProfile? profile,
    List<ProfilePackage> packages = const [],
    bool isFollowing = false,
  }) : this(
         status: ProfileStatus.refreshing,
         profile: profile,
         packages: packages,
         isFollowing: isFollowing,
       );

  final ProfileStatus status;
  final PromooProfile? profile;
  final List<ProfilePackage> packages;
  final AppFailure? failure;

  /// Local follow state (Phase A). Backend wiring will replace this with the
  /// real `is_following` flag and POST/DELETE `/follows`.
  final bool isFollowing;

  bool get isRefreshing => status == ProfileStatus.refreshing;

  bool get hasContent => profile != null;
}

class ProfileController extends Notifier<ProfileState> {
  var _disposed = false;

  @override
  ProfileState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const ProfileState.loading();
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return _load(showLoading: true);
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  /// Toggles the local follow state (Phase A). No-op until the profile loads.
  void toggleFollow() {
    final profile = state.profile;
    if (state.status != ProfileStatus.success || profile == null) {
      return;
    }
    state = ProfileState.success(
      profile: profile,
      packages: state.packages,
      isFollowing: !state.isFollowing,
    );
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final previousProfile = state.profile;
    final previousPackages = state.packages;

    if (refreshing) {
      state = ProfileState.refreshing(
        profile: previousProfile,
        packages: previousPackages,
      );
    } else if (showLoading) {
      state = const ProfileState.loading();
    }

    final target = ref.read(profileTargetProvider);
    final repository = ref.read(profileRepositoryProvider);
    final profileResult = target == null || target.trim().isEmpty
        ? await repository.getDemoProfile()
        : await repository.getProfile(target.trim());
    if (_disposed) {
      return;
    }

    await profileResult.when(
      success: (profile) async {
        final packagesResult = await repository.getProfilePackages(profile.id);
        if (_disposed) {
          return;
        }

        final packages = packagesResult.when(
          success: (items) => items,
          failure: (_) => const <ProfilePackage>[],
        );

        state = ProfileState.success(
          profile: profile,
          packages: packages,
          isFollowing: state.isFollowing,
        );
      },
      failure: (failure) async {
        if (failure.type == AppFailureType.notFound) {
          state = ProfileState.empty(failure: failure);
          return;
        }

        state = ProfileState.error(
          failure: failure,
          profile: refreshing ? previousProfile : null,
          packages: refreshing ? previousPackages : const [],
        );
      },
    );
  }
}
