import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/chat/presentation/screens/chat_room_screen.dart';
import '../features/home/presentation/screens/home_content_detail_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/seats/presentation/screens/seats_screen.dart';
import '../features/services/presentation/screens/service_detail_screen.dart';
import '../features/services/presentation/screens/services_screen.dart';
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
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.chats,
        name: RouteNames.chats,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatRoomPath,
        name: RouteNames.chatRoom,
        builder: (context, state) {
          return ChatRoomScreen(roomId: state.pathParameters['roomId'] ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
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
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.homeContentDetail,
            name: RouteNames.homeContentDetail,
            builder: (context, state) {
              return HomeContentDetailScreen(
                type: state.pathParameters['type'] ?? '',
                itemId: state.pathParameters['id'] ?? '',
              );
            },
          ),
          GoRoute(
            path: AppRoutes.services,
            name: RouteNames.services,
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: AppRoutes.serviceDetail,
            name: RouteNames.serviceDetail,
            builder: (context, state) {
              return ServiceDetailScreen(
                serviceId: state.pathParameters['id'] ?? '',
              );
            },
          ),
          GoRoute(
            path: AppRoutes.cup,
            name: RouteNames.cup,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.seats,
            name: RouteNames.seats,
            builder: (context, state) => const SeatsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.profileDetail,
            name: RouteNames.profileDetail,
            builder: (context, state) {
              return ProfileScreen(idOrUsername: state.pathParameters['id']);
            },
          ),
          GoRoute(
            path: AppRoutes.search,
            name: RouteNames.search,
            builder: (context, state) => const SearchScreen(),
          ),
        ],
      ),
    ],
  );
}

int _selectedIndexForPath(String path) {
  return switch (path) {
    AppRoutes.services => 1,
    _ when path.startsWith('/home/items/') => 0,
    _ when path.startsWith('/services/') => 1,
    AppRoutes.cup => 2,
    AppRoutes.seats => 3,
    AppRoutes.profile => 4,
    _ when path.startsWith('/profiles/') => 4,
    AppRoutes.search => 0,
    _ => 0,
  };
}
