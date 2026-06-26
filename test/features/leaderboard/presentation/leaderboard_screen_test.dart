import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/domain/entities/leaderboard_profile.dart';
import 'package:promoo_app/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:promoo_app/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:promoo_app/features/leaderboard/presentation/widgets/leaderboard_podium.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildLeaderboardScreen(_PendingLeaderboardRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading leaderboard'), findsOneWidget);
  });

  testWidgets('renders leaderboard content', (tester) async {
    await tester.pumpWidget(
      _buildLeaderboardScreen(
        const _LeaderboardRepository(
          result: Result.success([
            LeaderboardProfile(
              id: 'profile-1',
              rank: LeaderboardRank(1),
              displayName: 'Noura Studio',
              username: 'noura.studio',
              accountType: 'company',
              followersCount: 185400,
              isVerified: true,
            ),
            LeaderboardProfile(
              id: 'profile-2',
              rank: LeaderboardRank(2),
              displayName: 'Omar Creative',
              accountType: 'influencer',
              followersCount: 142900,
            ),
          ]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cup'), findsOneWidget);
    expect(find.byType(LeaderboardPodium), findsOneWidget);
    expect(find.text('Top of the Cup'), findsOneWidget);
    expect(find.text('Ranking'), findsOneWidget);
    expect(find.text('Noura Studio'), findsWidgets);
    expect(find.text('185.4K followers'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildLeaderboardScreen(
        const _LeaderboardRepository(
          result: Result.failure(AppFailure.network(message: 'No connection')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load leaderboard'), findsOneWidget);
    expect(find.text('No connection'), findsOneWidget);
  });
}

Widget _buildLeaderboardScreen(LeaderboardRepository repository) {
  return ProviderScope(
    overrides: [leaderboardRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const Scaffold(body: LeaderboardScreen()),
    ),
  );
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

class _PendingLeaderboardRepository implements LeaderboardRepository {
  const _PendingLeaderboardRepository(this.completer);

  final Completer<Result<List<LeaderboardProfile>>> completer;

  @override
  Future<Result<List<LeaderboardProfile>>> getLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) {
    return completer.future;
  }
}
