import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/domain/entities/leaderboard_profile.dart';
import 'package:promoo_app/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:promoo_app/features/leaderboard/presentation/controllers/leaderboard_controller.dart';

void main() {
  test('emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        leaderboardRepositoryProvider.overrideWithValue(
          const _LeaderboardRepository(
            result: Result.success([
              LeaderboardProfile(
                id: 'profile-1',
                rank: LeaderboardRank(1),
                displayName: 'Noura Studio',
                followersCount: 185400,
              ),
            ]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(leaderboardControllerProvider).status,
      LeaderboardStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(leaderboardControllerProvider);
    expect(state.status, LeaderboardStatus.success);
    expect(state.profiles.single.displayName, 'Noura Studio');
  });

  test('emits empty when repository returns no profiles', () async {
    final container = ProviderContainer(
      overrides: [
        leaderboardRepositoryProvider.overrideWithValue(
          const _LeaderboardRepository(result: Result.success([])),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(leaderboardControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(leaderboardControllerProvider);
    expect(state.status, LeaderboardStatus.empty);
    expect(state.profiles, isEmpty);
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        leaderboardRepositoryProvider.overrideWithValue(
          const _LeaderboardRepository(
            result: Result.failure(
              AppFailure.network(message: 'No connection'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(leaderboardControllerProvider).status,
      LeaderboardStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(leaderboardControllerProvider);
    expect(state.status, LeaderboardStatus.error);
    expect(state.failure?.message, 'No connection');
  });
}

class _LeaderboardRepository implements LeaderboardRepository {
  const _LeaderboardRepository({required this.result});

  final Result<List<LeaderboardProfile>> result;

  @override
  Future<Result<List<LeaderboardProfile>>> getLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    return result;
  }
}
