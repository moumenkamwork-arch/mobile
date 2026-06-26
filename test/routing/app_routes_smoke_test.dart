import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  const mockConfig = AppConfig(
    environment: AppEnvironment.development,
    baseUrl: 'https://api.promoo.test/api/v1',
    useMocks: true,
  );

  final routeCases = <_RouteSmokeCase>[
    const _RouteSmokeCase(AppRoutes.splash, 'Welcome to Promoo'),
    const _RouteSmokeCase(AppRoutes.home, 'Promoo'),
    _RouteSmokeCase(
      AppRoutes.homeItemDetail('offer', 'offer-1'),
      'Launch week promotion',
    ),
    const _RouteSmokeCase(AppRoutes.services, 'Services'),
    _RouteSmokeCase(
      AppRoutes.serviceById('service-content'),
      'Premium content package',
    ),
    const _RouteSmokeCase(AppRoutes.cup, 'Cup'),
    const _RouteSmokeCase(AppRoutes.seats, 'Influencer Seats'),
    const _RouteSmokeCase(AppRoutes.profile, 'Noura Studio'),
    _RouteSmokeCase(AppRoutes.profileById('noura.studio'), 'Noura Studio'),
    const _RouteSmokeCase(AppRoutes.search, 'Search Promoo'),
    const _RouteSmokeCase(
      AppRoutes.login,
      'Sign in to access your Promoo actions.',
    ),
    const _RouteSmokeCase(
      AppRoutes.register,
      'Create your Promoo account with email.',
    ),
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
