import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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
    this.isBlocked = false,
  });

  const ProfileState.loading() : this(status: ProfileStatus.loading);

  const ProfileState.success({
    required PromooProfile profile,
    List<ProfilePackage> packages = const [],
    bool isFollowing = false,
    bool isBlocked = false,
  }) : this(
         status: ProfileStatus.success,
         profile: profile,
         packages: packages,
         isFollowing: isFollowing,
         isBlocked: isBlocked,
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

  /// Whether the signed-in user follows this profile. Seeded on load from
  /// `GET /follows/:id/status` and driven by `toggleFollow` (POST/DELETE
  /// `/follows/:id`). Always false for a guest or one's own profile.
  final bool isFollowing;

  /// Whether the signed-in user has blocked this profile. Same lifecycle as
  /// [isFollowing] but backed by `GET/POST/DELETE /blocks/:id`.
  final bool isBlocked;

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

  /// Patches the loaded profile in place (e.g. right after
  /// `POST /profiles/me/avatar` already returned the fresh row) so every
  /// watcher — the Profile Management welcome card included — updates
  /// instantly. Safer than `ref.invalidate` + waiting for a re-fetch to win
  /// the race against navigation back to a screen that's already watching.
  void applyProfile(PromooProfile profile) {
    state = ProfileState.success(
      profile: profile,
      packages: state.packages,
      isFollowing: state.isFollowing,
      isBlocked: state.isBlocked,
    );
  }

  /// Optimistically toggles follow, then calls the backend
  /// (`POST`/`DELETE /follows/:id`). Reverts if the request fails (e.g. a guest
  /// gets 401). No-op until the profile has loaded.
  Future<void> toggleFollow() async {
    final profile = state.profile;
    if (state.status != ProfileStatus.success || profile == null) {
      return;
    }

    final wasFollowing = state.isFollowing;
    state = ProfileState.success(
      profile: profile,
      packages: state.packages,
      isFollowing: !wasFollowing,
      isBlocked: state.isBlocked,
    );

    final repository = ref.read(profileRepositoryProvider);
    final result = wasFollowing
        ? await repository.unfollowProfile(profile.id)
        : await repository.followProfile(profile.id);
    if (_disposed) {
      return;
    }

    result.when(
      success: (_) {},
      failure: (_) {
        // Revert to the pre-tap state on failure.
        if (state.status == ProfileStatus.success && state.profile != null) {
          state = ProfileState.success(
            profile: state.profile!,
            packages: state.packages,
            isFollowing: wasFollowing,
            isBlocked: state.isBlocked,
          );
        }
      },
    );
  }

  /// Optimistically toggles block, then calls the backend
  /// (`POST`/`DELETE /blocks/:id`). Reverts if the request fails. No-op until
  /// the profile has loaded. Returns `true` if the request succeeded, so the
  /// UI can show the right confirmation vs an error (previously it always
  /// claimed success even when the request failed and silently reverted).
  Future<bool> toggleBlock() async {
    final profile = state.profile;
    if (state.status != ProfileStatus.success || profile == null) {
      return false;
    }

    final wasBlocked = state.isBlocked;
    state = ProfileState.success(
      profile: profile,
      packages: state.packages,
      isFollowing: state.isFollowing,
      isBlocked: !wasBlocked,
    );

    final repository = ref.read(profileRepositoryProvider);
    final result = wasBlocked
        ? await repository.unblockProfile(profile.id)
        : await repository.blockProfile(profile.id);
    if (_disposed) {
      return result.isSuccess;
    }

    return result.when(
      success: (_) => true,
      failure: (_) {
        if (state.status == ProfileStatus.success && state.profile != null) {
          state = ProfileState.success(
            profile: state.profile!,
            packages: state.packages,
            isFollowing: state.isFollowing,
            isBlocked: wasBlocked,
          );
        }
        return false;
      },
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

    final isOwner = target == null || target.trim().isEmpty;
    final isSignedIn = ref.read(authControllerProvider).session != null;

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

        // Follow status only applies to *other* people's profiles and needs a
        // signed-in caller (the endpoint is auth-only). Guests / own profile
        // keep isFollowing = false.
        var isFollowing = false;
        var isBlocked = false;
        if (!isOwner && isSignedIn) {
          final statusResult = await repository.getFollowStatus(profile.id);
          if (_disposed) {
            return;
          }
          isFollowing = statusResult.when(
            success: (value) => value,
            failure: (_) => false,
          );

          final blockStatusResult = await repository.getBlockStatus(
            profile.id,
          );
          if (_disposed) {
            return;
          }
          isBlocked = blockStatusResult.when(
            success: (value) => value,
            failure: (_) => false,
          );
        }

        state = ProfileState.success(
          profile: profile,
          packages: packages,
          isFollowing: isFollowing,
          isBlocked: isBlocked,
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
