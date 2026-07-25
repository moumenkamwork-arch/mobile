import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/chat/data/datasources/chat_fake_data_source.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/home/data/datasources/home_fake_data_source.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/data/datasources/leaderboard_fake_data_source.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/notifications/data/datasources/notifications_fake_data_source.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:promoo_app/features/profile/data/datasources/profile_fake_data_source.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/seats/data/datasources/seats_fake_data_source.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/services/data/datasources/services_fake_data_source.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  const mockConfig = AppConfig();

  final routeCases = <_RouteSmokeCase>[
    const _RouteSmokeCase(AppRoutes.splash, 'Continue as Guest'),
    const _RouteSmokeCase(AppRoutes.home, 'Top Offers'),
    _RouteSmokeCase(
      AppRoutes.homeItemDetail('offer', 'offer-1'),
      'Cafe opening spotlight',
    ),
    const _RouteSmokeCase(AppRoutes.services, 'Services'),
    _RouteSmokeCase(
      AppRoutes.serviceById('service-influencer-launch'),
      'Boutique influencer launch package',
    ),
    const _RouteSmokeCase(AppRoutes.cup, 'Cup'),
    const _RouteSmokeCase(AppRoutes.seats, 'Gold Seats'),
    // No longer a bottom-nav tab, but the route/screen itself still works.
    _RouteSmokeCase(AppRoutes.offers, 'Cafe opening spotlight'),
    _RouteSmokeCase(
      AppRoutes.seatCheckout(
        seatId: 'seat-gold-2',
        title: 'Gold Seat 2',
        tier: 'Gold visibility placement',
        price: '2500 AED',
      ),
      'Checkout preview',
    ),
    const _RouteSmokeCase(AppRoutes.profile, 'Profile Management'),
    _RouteSmokeCase(
      AppRoutes.profileById('saffron.social'),
      'Saffron Social Studio',
    ),
    const _RouteSmokeCase(AppRoutes.search, 'Search Promoo'),
    const _RouteSmokeCase(AppRoutes.login, 'Continue as Guest'),
    const _RouteSmokeCase(AppRoutes.register, 'Continue as Guest'),
    const _RouteSmokeCase(AppRoutes.chats, 'Chats'),
    _RouteSmokeCase(AppRoutes.chatRoom('chat-room-1'), 'Conversation'),
    const _RouteSmokeCase(AppRoutes.notifications, 'Notifications'),
  ];

  for (final routeCase in routeCases) {
    testWidgets('renders ${routeCase.path}', (tester) async {
      final router = createAppRouter(initialLocation: routeCase.path);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(mockConfig),
            // Chat/Notifications read the session store for the access
            // token; the real SecureAuthSessionStore's platform channel
            // call never resolves under testWidgets.
            authSessionStoreProvider.overrideWithValue(
              InMemoryAuthSessionStore(),
            ),
            // Profile screens (Profile Management + public profile) now hit
            // the real profile repository by default.
            profileRepositoryProvider.overrideWithValue(
              ProfileRepositoryImpl(
                config: mockConfig,
                dataSource: ProfileFakeDataSource(),
              ),
            ),
            // Home now hits the real backend by default.
            homeRepositoryProvider.overrideWithValue(
              HomeRepositoryImpl(
                config: mockConfig,
                dataSource: const HomeFakeDataSource(),
              ),
            ),
            // Services + Leaderboard (Cup) now hit the real backend by
            // default.
            servicesRepositoryProvider.overrideWithValue(
              ServicesRepositoryImpl(
                config: mockConfig,
                dataSource: const ServicesFakeDataSource(),
              ),
            ),
            leaderboardRepositoryProvider.overrideWithValue(
              const LeaderboardRepositoryImpl(
                dataSource: LeaderboardFakeDataSource(),
              ),
            ),
            // Seats now hits the real backend by default (Phase 6).
            seatsRepositoryProvider.overrideWithValue(
              SeatsRepositoryImpl(
                config: mockConfig,
                dataSource: const SeatsFakeDataSource(),
              ),
            ),
            // Chat now hits the real backend by default (Phase 9).
            chatRepositoryProvider.overrideWithValue(
              ChatRepositoryImpl(
                dataSource: ChatFakeDataSource(),
                sessionStore: InMemoryAuthSessionStore(),
              ),
            ),
            // Notifications now hit the real backend by default (Phase 10);
            // the header badge reads this on every route, so keep the smoke
            // test offline with the fake source.
            notificationsRepositoryProvider.overrideWithValue(
              NotificationsRepositoryImpl(
                dataSource: NotificationsFakeDataSource(),
                sessionStore: InMemoryAuthSessionStore(),
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

      expect(tester.takeException(), isNull);
      expect(find.text(routeCase.expectedText), findsAtLeastNWidgets(1));
    });
  }
}

class _RouteSmokeCase {
  const _RouteSmokeCase(this.path, this.expectedText);

  final String path;
  final String expectedText;
}
