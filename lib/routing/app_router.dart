import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shell/placeholder_tab_screen.dart';
import '../shell/promoo_shell.dart';
import '../shell/splash_placeholder_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter();
});

GoRouter createAppRouter({String initialLocation = AppRoutes.splash}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPlaceholderScreen(),
      ),
      GoRoute(
        path: AppRoutes.splashAlias,
        name: RouteNames.splashAlias,
        builder: (context, state) => const SplashPlaceholderScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return PromooShell(
            selectedIndex: _selectedIndexForPath(state.uri.path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: RouteNames.home,
            builder: (context, state) => const PlaceholderTabScreen(
              title: 'Home',
              description: 'Home vertical slice is not started yet.',
              icon: Icons.home_rounded,
            ),
          ),
          GoRoute(
            path: AppRoutes.services,
            name: RouteNames.services,
            builder: (context, state) => const PlaceholderTabScreen(
              title: 'Services',
              description: 'Services vertical slice is not started yet.',
              icon: Icons.storefront_rounded,
            ),
          ),
          GoRoute(
            path: AppRoutes.cup,
            name: RouteNames.cup,
            builder: (context, state) => const PlaceholderTabScreen(
              title: 'Cup',
              description: 'Leaderboard vertical slice is not started yet.',
              icon: Icons.emoji_events_rounded,
            ),
          ),
          GoRoute(
            path: AppRoutes.seats,
            name: RouteNames.seats,
            builder: (context, state) => const PlaceholderTabScreen(
              title: 'Seats',
              description: 'Seats vertical slice is not started yet.',
              icon: Icons.event_seat_rounded,
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: RouteNames.profile,
            builder: (context, state) => const PlaceholderTabScreen(
              title: 'Profile',
              description: 'Profile vertical slice is not started yet.',
              icon: Icons.person_rounded,
            ),
          ),
        ],
      ),
    ],
  );
}

int _selectedIndexForPath(String path) {
  return switch (path) {
    AppRoutes.services => 1,
    AppRoutes.cup => 2,
    AppRoutes.seats => 3,
    AppRoutes.profile => 4,
    _ => 0,
  };
}
