import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/leaderboard_repository_impl.dart';
import '../../domain/entities/leaderboard_profile.dart';

final leaderboardControllerProvider =
    NotifierProvider<LeaderboardController, LeaderboardState>(
      LeaderboardController.new,
    );

enum LeaderboardStatus { loading, success, empty, error, refreshing }

class LeaderboardState {
  const LeaderboardState({
    required this.status,
    this.profiles = const [],
    this.type = LeaderboardType.all,
    this.failure,
  });

  const LeaderboardState.loading() : this(status: LeaderboardStatus.loading);

  const LeaderboardState.success({
    required List<LeaderboardProfile> profiles,
    LeaderboardType type = LeaderboardType.all,
  }) : this(status: LeaderboardStatus.success, profiles: profiles, type: type);

  const LeaderboardState.empty({LeaderboardType type = LeaderboardType.all})
    : this(status: LeaderboardStatus.empty, type: type);

  const LeaderboardState.error({
    required AppFailure failure,
    List<LeaderboardProfile> profiles = const [],
    LeaderboardType type = LeaderboardType.all,
  }) : this(
         status: LeaderboardStatus.error,
         failure: failure,
         profiles: profiles,
         type: type,
       );

  const LeaderboardState.refreshing({
    required List<LeaderboardProfile> profiles,
    LeaderboardType type = LeaderboardType.all,
  }) : this(
         status: LeaderboardStatus.refreshing,
         profiles: profiles,
         type: type,
       );

  final LeaderboardStatus status;
  final List<LeaderboardProfile> profiles;
  final LeaderboardType type;
  final AppFailure? failure;

  bool get isRefreshing => status == LeaderboardStatus.refreshing;

  bool get hasContent => profiles.isNotEmpty;
}

class LeaderboardController extends Notifier<LeaderboardState> {
  var _disposed = false;

  @override
  LeaderboardState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const LeaderboardState.loading();
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

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final currentProfiles = state.profiles;
    final type = state.type;

    if (refreshing) {
      state = LeaderboardState.refreshing(
        profiles: currentProfiles,
        type: type,
      );
    } else if (showLoading) {
      state = const LeaderboardState.loading();
    }

    final repository = ref.read(leaderboardRepositoryProvider);
    final result = await repository.getLeaderboard(type: type);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (profiles) {
        if (profiles.isEmpty) {
          return LeaderboardState.empty(type: type);
        }
        return LeaderboardState.success(profiles: profiles, type: type);
      },
      failure: (failure) {
        return LeaderboardState.error(
          failure: failure,
          profiles: refreshing ? currentProfiles : const [],
          type: type,
        );
      },
    );
  }
}
