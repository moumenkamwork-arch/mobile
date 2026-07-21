import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/profile/domain/entities/follow_user.dart';
import 'package:promoo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:promoo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:promoo_app/features/auth/presentation/screens/register_screen.dart';
import 'package:promoo_app/features/chat/data/datasources/chat_fake_data_source.dart';
import 'package:promoo_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:promoo_app/features/notifications/data/datasources/notifications_fake_data_source.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:promoo_app/features/home/data/datasources/home_fake_data_source.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('login screen renders and validates input', (tester) async {
    await tester.pumpWidget(
      _buildAuthScreen(const LoginScreen(), const _AuthRepository()),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
    expect(find.bySemanticsLabel('Promoo auth logo'), findsOneWidget);
    final authLogo = tester.widget<PromooLogo>(
      _promooLogoWithLabel('Promoo auth logo'),
    );
    expect(authLogo.height, 96);

    await tester.scrollUntilVisible(
      find.byTooltip('Google'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Apple'), findsOneWidget);
    expect(find.byTooltip('Google'), findsOneWidget);
    expect(find.byTooltip('Facebook'), findsNothing);

    await tester.tap(find.byTooltip('Google'));
    await tester.pumpAndSettle();
    expect(find.text('Google sign-in coming soon'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Login'),
      -160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required.'), findsOneWidget);
  });

  testWidgets('guest access navigates from login to Home in mock mode', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.login);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(_mockConfig),
          authRepositoryProvider.overrideWithValue(const _AuthRepository()),
          // This test navigates on to Home, which now hits the real
          // backend by default.
          homeRepositoryProvider.overrideWithValue(
            HomeRepositoryImpl(
              config: _mockConfig,
              dataSource: const HomeFakeDataSource(),
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

    await tester.ensureVisible(find.text('Continue as Guest'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    expect(find.text('Top Offers'), findsOneWidget);
  });

  testWidgets('login screen shows authenticated panel after submit', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildAuthScreen(const LoginScreen(), const _AuthRepository()),
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'alya@promoo.app',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'password123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Signed in'), findsOneWidget);
    expect(find.text('Alya Hassan'), findsOneWidget);
  });

  testWidgets('register screen renders account type controls', (tester) async {
    await tester.pumpWidget(
      _buildAuthScreen(const RegisterScreen(), const _AuthRepository()),
    );

    expect(find.text('Create account'), findsWidgets);
    expect(find.text('Continue as Guest'), findsOneWidget);
    expect(find.bySemanticsLabel('Promoo auth logo'), findsOneWidget);
    expect(find.text('Account type'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);
    expect(find.text('Influencer'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byTooltip('Apple'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Apple'), findsOneWidget);
    expect(find.byTooltip('Google'), findsOneWidget);
    expect(find.byTooltip('Facebook'), findsNothing);
  });

  testWidgets('profile Message action opens a chat room', (tester) async {
    final router = createAppRouter(
      initialLocation: AppRoutes.profileById('lina.atelier'),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(const _AuthRepository()),
          profileRepositoryProvider.overrideWithValue(
            const _ProfileRepository(
              profileResult: Result.success(_profile),
              packagesResult: Result.success([]),
            ),
          ),
          // The chat room this test navigates into reads the session store
          // for the access token; the real SecureAuthSessionStore's platform
          // channel call never resolves under testWidgets.
          authSessionStoreProvider.overrideWithValue(InMemoryAuthSessionStore()),
          // Chat now hits the real backend by default (Phase 9) — keep this
          // navigation test on the fake.
          chatRepositoryProvider.overrideWithValue(
            ChatRepositoryImpl(
              dataSource: ChatFakeDataSource(),
              sessionStore: InMemoryAuthSessionStore(),
            ),
          ),
          // Notifications likewise hit the real backend by default (Phase 10);
          // Home's header badge reads this, so keep it on the fake here.
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

    await tester.ensureVisible(find.text('Message'));
    await tester.tap(find.text('Message'));
    await tester.pumpAndSettle();

    // The Message action pushes into a conversation with a working composer.
    expect(find.text('Conversation'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });
}

Widget _buildAuthScreen(Widget screen, AuthRepository repository) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: screen,
    ),
  );
}

Finder _promooLogoWithLabel(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is PromooLogo && widget.semanticLabel == label,
  );
}

const _session = AuthSession(
  user: AuthUser(
    id: 'user-1',
    email: 'alya@promoo.app',
    fullName: 'Alya Hassan',
  ),
  tokens: AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
);

const _mockConfig = AppConfig();

const _profile = PromooProfile(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
  username: 'saffron.social',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(followers: 185400, services: 1),
);

class _AuthRepository implements AuthRepository {
  const _AuthRepository();

  static const loginResult = Result.success(_session);
  static const storedSessionResult = Result.success(null);

  @override
  Future<Result<AuthSession?>> getStoredSession() async {
    return storedSessionResult;
  }

  @override
  Future<Result<AuthSession>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return loginResult;
  }

  @override
  Future<Result<AuthSession>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    return loginResult;
  }

  @override
  Future<Result<AuthSession>> refreshSession() async {
    return loginResult;
  }

  @override
  Future<Result<void>> logout() async {
    return const Result.success(null);
  }

}

class _ProfileRepository implements ProfileRepository {
  const _ProfileRepository({
    required this.profileResult,
    required this.packagesResult,
  });

  final Result<PromooProfile> profileResult;
  final Result<List<ProfilePackage>> packagesResult;

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    return profileResult;
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(
    String profileId,
  ) async {
    return packagesResult;
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(
    ProfileUpdateDraft draft,
  ) async {
    return const Result.failure(
      AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
    );
  }

  @override
  Future<Result<PromooProfile>> updateMyAvatar(String avatarUrl) async =>
      const Result.failure(AppFailure.unauthorized());

  @override
  Future<Result<PromooProfile>> updateMyCover(String coverUrl) async =>
      const Result.failure(AppFailure.unauthorized());

  @override
  Future<Result<bool>> getFollowStatus(String profileId) async =>
      const Result.success(false);

  @override
  Future<Result<void>> followProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<void>> unfollowProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<List<FollowUser>>> getFollowing(String profileId) async =>
      const Result.success(<FollowUser>[]);
}
