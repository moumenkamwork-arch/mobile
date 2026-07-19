import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/follow_user.dart';

final followingControllerProvider =
    NotifierProvider<FollowingController, FollowingState>(
      FollowingController.new,
    );

enum FollowingStatus { loading, success, empty, error }

class FollowingState {
  const FollowingState({
    required this.status,
    this.users = const [],
    this.failure,
  });

  const FollowingState.loading() : this(status: FollowingStatus.loading);
  const FollowingState.empty() : this(status: FollowingStatus.empty);
  const FollowingState.success(List<FollowUser> users)
    : this(status: FollowingStatus.success, users: users);
  const FollowingState.error(AppFailure failure)
    : this(status: FollowingStatus.error, failure: failure);

  final FollowingStatus status;
  final List<FollowUser> users;
  final AppFailure? failure;
}

class FollowingController extends Notifier<FollowingState> {
  var _disposed = false;

  @override
  FollowingState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const FollowingState.loading();
  }

  Future<void> load() async {
    // "My following" — needs the signed-in user's id (endpoint is auth-only).
    final userId = ref.read(authControllerProvider).session?.user.id;
    if (userId == null) {
      state = const FollowingState.empty();
      return;
    }

    state = const FollowingState.loading();
    final result = await ref
        .read(profileRepositoryProvider)
        .getFollowing(userId);
    if (_disposed) return;

    state = result.when(
      success: (users) => users.isEmpty
          ? const FollowingState.empty()
          : FollowingState.success(users),
      failure: FollowingState.error,
    );
  }

  Future<void> retry() => load();

  /// Optimistically removes the row and calls `DELETE /follows/:id`. Reverts on
  /// failure.
  Future<void> unfollow(String profileId) async {
    final current = state;
    if (current.status != FollowingStatus.success) return;

    final remaining =
        current.users.where((u) => u.id != profileId).toList();
    state = remaining.isEmpty
        ? const FollowingState.empty()
        : FollowingState.success(remaining);

    final result = await ref
        .read(profileRepositoryProvider)
        .unfollowProfile(profileId);
    if (_disposed) return;

    result.when(success: (_) {}, failure: (_) => state = current);
  }
}
