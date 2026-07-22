import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/follow_user.dart';

final blockedUsersControllerProvider =
    NotifierProvider<BlockedUsersController, BlockedUsersState>(
      BlockedUsersController.new,
    );

enum BlockedUsersStatus { loading, success, empty, error }

class BlockedUsersState {
  const BlockedUsersState({
    required this.status,
    this.users = const [],
    this.failure,
  });

  const BlockedUsersState.loading() : this(status: BlockedUsersStatus.loading);
  const BlockedUsersState.empty() : this(status: BlockedUsersStatus.empty);
  const BlockedUsersState.success(List<FollowUser> users)
    : this(status: BlockedUsersStatus.success, users: users);
  const BlockedUsersState.error(AppFailure failure)
    : this(status: BlockedUsersStatus.error, failure: failure);

  final BlockedUsersStatus status;
  final List<FollowUser> users;
  final AppFailure? failure;
}

class BlockedUsersController extends Notifier<BlockedUsersState> {
  var _disposed = false;

  @override
  BlockedUsersState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const BlockedUsersState.loading();
  }

  Future<void> load() async {
    final signedIn = ref.read(authControllerProvider).session != null;
    if (!signedIn) {
      state = const BlockedUsersState.empty();
      return;
    }

    state = const BlockedUsersState.loading();
    final result = await ref.read(profileRepositoryProvider).getBlockedUsers();
    if (_disposed) return;

    state = result.when(
      success: (users) => users.isEmpty
          ? const BlockedUsersState.empty()
          : BlockedUsersState.success(users),
      failure: BlockedUsersState.error,
    );
  }

  Future<void> retry() => load();

  /// Optimistically removes the row and calls `DELETE /blocks/:id`. Reverts
  /// on failure.
  Future<void> unblock(String profileId) async {
    final current = state;
    if (current.status != BlockedUsersStatus.success) return;

    final remaining = current.users.where((u) => u.id != profileId).toList();
    state = remaining.isEmpty
        ? const BlockedUsersState.empty()
        : BlockedUsersState.success(remaining);

    final result = await ref
        .read(profileRepositoryProvider)
        .unblockProfile(profileId);
    if (_disposed) return;

    result.when(success: (_) {}, failure: (_) => state = current);
  }
}
