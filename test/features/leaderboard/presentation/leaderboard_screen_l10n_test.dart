import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/domain/entities/leaderboard_profile.dart';
import 'package:promoo_app/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:promoo_app/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'leaderboard screen renders Arabic titles and follower counts, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            leaderboardRepositoryProvider.overrideWithValue(
              const _LeaderboardRepository(
                result: Result.success([
                  LeaderboardProfile(
                    id: 'profile-1',
                    rank: LeaderboardRank(1),
                    displayName: 'Saffron Social Studio',
                    accountType: 'company',
                    followersCount: 185400,
                  ),
                  LeaderboardProfile(
                    id: 'profile-2',
                    rank: LeaderboardRank(2),
                    displayName: 'Lina Atelier',
                    accountType: 'influencer',
                    followersCount: 800,
                  ),
                ]),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Mirrors lib/app.dart: translate, don't mirror the layout.
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const Scaffold(body: LeaderboardScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الكأس'), findsOneWidget);
      // Champion (185,400 → compact "185.4K") uses the compact-count phrase.
      expect(find.text('البطل / 185.4K متابع'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('الترتيب'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('الترتيب'), findsOneWidget);
      // Runner-up (800, below 1000) uses real Arabic plural grammar. It now
      // appears in two places — on the podium and in the standings row — so
      // this asserts the grammar renders, not a single occurrence.
      expect(find.text('800 متابع'), findsWidgets);

      expect(
        Directionality.of(tester.element(find.text('الترتيب'))),
        TextDirection.ltr,
      );
    },
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
