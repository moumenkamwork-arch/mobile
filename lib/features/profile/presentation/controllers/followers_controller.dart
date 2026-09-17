import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/follow_user.dart';

final followersControllerProvider =
    NotifierProvider<FollowersController, FollowersState>(
      FollowersController.new,
    );

enum FollowersStatus { loading, success, empty, error }

class FollowersState {
  const FollowersState({
    required this.status,
    this.users = const [],
    this.failure,
  });

  const FollowersState.loading() : this(status: FollowersStatus.loading);
  const FollowersState.empty() : this(status: FollowersStatus.empty);
  const FollowersState.success(List<FollowUser> users)
    : this(status: FollowersStatus.success, users: users);
  const FollowersState.error(AppFailure failure)
    : this(status: FollowersStatus.error, failure: failure);

  final FollowersStatus status;
  final List<FollowUser> users;
  final AppFailure? failure;
}

class FollowersController extends Notifier<FollowersState> {
  var _disposed = false;

  @override
  FollowersState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const FollowersState.loading();
  }

  Future<void> load() async {
    // "My followers" — needs the signed-in user's id (endpoint is auth-only).
    final userId = ref.read(authControllerProvider).session?.user.id;
    if (userId == null) {
      state = const FollowersState.empty();
      return;
    }

    state = const FollowersState.loading();
    final result = await ref
        .read(profileRepositoryProvider)
        .getFollowers(userId);
    if (_disposed) return;

    state = result.when(
      success: (users) => users.isEmpty
          ? const FollowersState.empty()
          : FollowersState.success(users),
      failure: FollowersState.error,
    );
  }

  Future<void> retry() => load();
}
