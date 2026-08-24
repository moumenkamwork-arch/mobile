import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/data/session/auth_session_store.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/chat/presentation/screens/chat_room_screen.dart';
import '../features/home/presentation/screens/home_content_detail_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/home_see_all_screen.dart';
import '../features/home/presentation/screens/offers_screen.dart';
import '../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/add_offer_screen.dart';
import '../features/profile/presentation/screens/add_service_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/my_listings/presentation/screens/my_listings_screen.dart';
import '../features/profile/presentation/screens/blocked_users_screen.dart';
import '../features/profile/presentation/screens/followers_screen.dart';
import '../features/profile/presentation/screens/following_screen.dart';
import '../features/profile/presentation/screens/my_packages_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/saved_items_screen.dart';
import '../features/profile/presentation/screens/static_info_screen.dart';
import '../features/profile/presentation/screens/support_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/seats/presentation/screens/seat_checkout_preview_screen.dart';
import '../features/seats/presentation/screens/seats_screen.dart';
import '../features/services/presentation/screens/service_detail_screen.dart';
import '../features/services/presentation/screens/services_screen.dart';
import '../shell/promoo_shell.dart';
import '../shell/splash_placeholder_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter();
});

/// Every one of these hits an endpoint scoped to the signed-in user (own
/// chats, own notifications, editing/publishing as that account, own
/// saved/following/followers/blocked/listings) — a guest would only ever get
/// a 401 past this point. Matched as path prefixes against
/// [GoRouterState.matchedLocation], so `/chats` also covers `/chats/:roomId`.
///
/// Deliberately NOT here: `/profile` (the menu itself renders a reduced,
/// guest-safe view — see `ProfileMenuScreen`), `/profile/support`,
/// `/profile/info/:topic`, `/profiles/:id`, and every browse/detail screen
/// (Home, Services, Cup, Seats, Search, offer/service detail) — those are
/// public by design; only the authenticated actions embedded in them
/// (follow/save/message/report) are gated, individually, at the point of use.
const _protectedPathPrefixes = <String>[
  AppRoutes.chats,
  AppRoutes.notifications,
  AppRoutes.profileEdit,
  AppRoutes.profileAddOffer,
  AppRoutes.profileAddService,
  AppRoutes.profileSaved,
  AppRoutes.profilePackages,
  AppRoutes.profileFollowing,
  AppRoutes.profileFollowers,
  AppRoutes.profileBlockedUsers,
  AppRoutes.profileMyListings,
];

bool _isProtectedLocation(String location) {
  return _protectedPathPrefixes.any(
    (prefix) => location == prefix || location.startsWith('$prefix/'),
  );
}

/// Bridges Riverpod's auth state into GoRouter's `refreshListenable`, so a
/// mid-session change (logout, or a session-restore that resolves shortly
/// after the very first redirect check — see [_authGuardRedirect]) makes the
/// router re-run redirect for whatever page is current, instead of only ever
/// checking once at initial navigation.
class _AuthRefreshListenable extends ChangeNotifier {
  ProviderSubscription<AuthState>? _subscription;

  /// Idempotent — the first redirect call binds this to the container that
  /// is actually in scope (the app's real container, or a test's), since
  /// [createAppRouter] itself is called before any `ProviderScope` exists.
  void bindOnce(ProviderContainer container) {
    if (_subscription != null) {
      return;
    }
    _subscription = container.listen<AuthState>(authControllerProvider, (
      previous,
      next,
    ) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}

/// Guards every path in [_protectedPathPrefixes], sending a guest to Login
/// instead of letting them render a screen that only 401s.
///
/// Checks the live [authControllerProvider] state first (the common case —
/// by the time a user taps into a protected screen, session restore has long
/// since settled). Falls back to reading [authSessionStoreProvider] directly
/// when the controller still reports unauthenticated, so a deep link straight
/// to a protected route on cold boot doesn't get bounced to Login just
/// because `AuthController`'s own async restore hasn't resolved yet.
///
/// Returns synchronously (no `Future` wrapping) whenever the destination
/// isn't protected — i.e. for almost every navigation in the app. GoRouter
/// awaits whatever `redirect` returns before building the destination page,
/// so an unconditionally-`async` version here would add a microtask of
/// latency to *every* navigation, not just the guarded ones — enough for a
/// bare `pumpWidget()` (no trailing `pump`/`pumpAndSettle`) to still be
/// showing the pre-navigation frame, which is exactly what broke the search
/// → detail navigation tests the first time this was wired up as `async`.
FutureOr<String?> _authGuardRedirect(BuildContext context, GoRouterState state) {
  if (!_isProtectedLocation(state.matchedLocation)) {
    return null;
  }

  final container = ProviderScope.containerOf(context, listen: false);
  if (container.read(authControllerProvider).isAuthenticated) {
    return null;
  }

  return _resolveFromPersistedSession(container);
}

Future<String?> _resolveFromPersistedSession(ProviderContainer container) async {
  final stored = await container.read(authSessionStoreProvider).read();
  if (stored != null && stored.isAuthenticated) {
    return null;
  }

  return AppRoutes.login;
}

GoRouter createAppRouter({String initialLocation = AppRoutes.splash}) {
  final authRefresh = _AuthRefreshListenable();

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      authRefresh.bindOnce(ProviderScope.containerOf(context, listen: false));
      return _authGuardRedirect(context, state);
    },
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
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 420),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
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
          final roomId = state.pathParameters['roomId'] ?? '';
          if (roomId == 'new') {
            final participantId = state.uri.queryParameters['participant'] ?? '';
            return ChatRoomScreen.newChat(participantId: participantId);
          }
          return ChatRoomScreen(roomId: roomId);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        name: RouteNames.profileEdit,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileAddOffer,
        name: RouteNames.profileAddOffer,
        builder: (context, state) => const AddOfferScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileAddService,
        name: RouteNames.profileAddService,
        builder: (context, state) => const AddServiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSaved,
        name: RouteNames.profileSaved,
        builder: (context, state) => const SavedItemsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profilePackages,
        name: RouteNames.profilePackages,
        builder: (context, state) => const MyPackagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileFollowing,
        name: RouteNames.profileFollowing,
        builder: (context, state) => const FollowingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileFollowers,
        name: RouteNames.profileFollowers,
        builder: (context, state) => const FollowersScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileBlockedUsers,
        name: RouteNames.profileBlockedUsers,
        builder: (context, state) => const BlockedUsersScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileMyListings,
        name: RouteNames.profileMyListings,
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSupport,
        name: RouteNames.profileSupport,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileInfoPath,
        name: RouteNames.profileInfo,
        builder: (context, state) {
          return StaticInfoScreen(
            topic: state.pathParameters['topic'] ?? 'about',
          );
        },
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
        path: AppRoutes.homeSeeAllPath,
        name: RouteNames.homeSeeAll,
        builder: (context, state) {
          return HomeSeeAllScreen(
            section: state.pathParameters['section'] ?? 'offers',
          );
        },
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
        path: AppRoutes.search,
        name: RouteNames.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.seatCheckoutPreview,
        name: RouteNames.seatCheckoutPreview,
        builder: (context, state) {
          final query = state.uri.queryParameters;
          return SeatCheckoutPreviewScreen(
            seatId: query['seatId'] ?? '',
            title: query['title'] ?? '',
            tierLabel: query['tier'] ?? '',
            priceLabel: query['price'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profileDetail,
        name: RouteNames.profileDetail,
        builder: (context, state) {
          return ProfileScreen(idOrUsername: state.pathParameters['id']);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          // Pass the raw path; the shell resolves the selected tab against its
          // own role-aware tab list (5 or 6 tabs), so the highlight stays
          // correct for every account type.
          return PromooShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),

          GoRoute(
            path: AppRoutes.services,
            name: RouteNames.services,
            builder: (context, state) => const ServicesScreen(),
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
          // Same bottom-nav slot as Seats (index 1), shown to non-influencers.
          GoRoute(
            path: AppRoutes.offers,
            name: RouteNames.offers,
            builder: (context, state) => const OffersScreen(),
          ),

          GoRoute(
            path: AppRoutes.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileMenuScreen(),
          ),
        ],
      ),
    ],
  );
}

