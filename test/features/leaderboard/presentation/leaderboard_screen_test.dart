import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/leaderboard/data/datasources/leaderboard_fake_data_source.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/domain/entities/leaderboard_profile.dart';
import 'package:promoo_app/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:promoo_app/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:promoo_app/features/leaderboard/presentation/widgets/leaderboard_podium.dart';
import 'package:promoo_app/features/profile/data/datasources/profile_fake_data_source.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
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
              displayName: 'Saffron Social Studio',
              username: 'saffron.social',
              accountType: 'company',
              followersCount: 185400,
              isVerified: true,
            ),
            LeaderboardProfile(
              id: 'profile-2',
              rank: LeaderboardRank(2),
              displayName: 'Lina Atelier',
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
    expect(find.text('Saffron Social Studio'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Ranking'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Ranking'), findsOneWidget);
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

  testWidgets('cup profile card opens public profile route', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.cup);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(_mockConfig),
          // This screen itself now hits the real leaderboard repository by
          // default.
          leaderboardRepositoryProvider.overrideWithValue(
            const LeaderboardRepositoryImpl(
              dataSource: LeaderboardFakeDataSource(),
            ),
          ),
          // The profile card navigates into a public profile screen, which
          // now hits the real profile repository by default.
          profileRepositoryProvider.overrideWithValue(
            ProfileRepositoryImpl(
              config: _mockConfig,
              dataSource: ProfileFakeDataSource(),
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saffron Social Studio').first);
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('@saffron.social'), findsOneWidget);
  });
}

const _mockConfig = AppConfig();

Widget _buildLeaderboardScreen(LeaderboardRepository repository) {
  return ProviderScope(
    overrides: [leaderboardRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
