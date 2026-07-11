import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
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
          overrides: [appConfigProvider.overrideWithValue(mockConfig)],
          child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
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
