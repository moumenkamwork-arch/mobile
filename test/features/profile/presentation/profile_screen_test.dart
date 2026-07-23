import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/profile/domain/entities/follow_user.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_spacing.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildProfileScreen(_PendingProfileRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading profile'), findsOneWidget);
  });

  testWidgets('own profile hides public actions and tools', (tester) async {
    await tester.pumpWidget(
      _buildProfileScreen(
        const _ProfileRepository(
          profileResult: Result.success(_profile),
          packagesResult: Result.success([_package]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final sliverPadding = tester.widget<SliverPadding>(
      find.byType(SliverPadding).first,
    );
    expect(
      sliverPadding.padding.resolve(TextDirection.ltr).bottom,
      AppSpacing.shellScrollBottom,
    );

    expect(find.text('Saffron Social Studio'), findsOneWidget);
    expect(find.text('@saffron.social'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Likes'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Views'), findsOneWidget);

    expect(find.text('Follow'), findsNothing);
    expect(find.text('Message'), findsNothing);
    expect(find.text('Profile tools'), findsNothing);
    // Owner sees the Edit profile action (it routes to the edit screen).
    expect(find.text('Edit profile'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Packages'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Packages'), findsAtLeastNWidgets(1));
    await tester.scrollUntilVisible(
      find.text('Boutique launch campaign'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Boutique launch campaign'), findsOneWidget);
    expect(find.text('2200 AED'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Media'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Media'), findsOneWidget);
    expect(find.text('Launch campaign spotlight'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile-media-tile-0')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('profile-media-viewer')), findsOneWidget);
    expect(find.text('Likes'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);

    await tester.tap(find.byTooltip('Close media'));
    await tester.pumpAndSettle();

    expect(find.text('Profile tools'), findsNothing);
  });

  testWidgets('follow button toggles to Following', (tester) async {
    await tester.pumpWidget(
      _buildProfileScreen(
        const _ProfileRepository(
          profileResult: Result.success(_profile),
          packagesResult: Result.success([_package]),
        ),
        idOrUsername: 'lina.atelier',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('Following'), findsNothing);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Follow'), findsNothing);
    // Message stays available alongside the follow toggle.
    expect(find.text('Message'), findsOneWidget);
  });

  testWidgets('renders empty media state', (tester) async {
    await tester.pumpWidget(
      _buildProfileScreen(
        const _ProfileRepository(
          profileResult: Result.success(_profileWithoutMedia),
          packagesResult: Result.success([]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('No media yet'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('No media yet'), findsOneWidget);
  });

  testWidgets('public profile route keeps management preview hidden', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildProfileScreen(
        const _ProfileRepository(
          profileResult: Result.success(_profile),
          packagesResult: Result.success([_package]),
        ),
        idOrUsername: 'saffron.social',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saffron Social Studio'), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Edit profile'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Boutique launch campaign'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile tools'), findsNothing);
    expect(find.text('Boutique launch campaign'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildProfileScreen(
        const _ProfileRepository(
          profileResult: Result.failure(
            AppFailure.network(message: 'No connection'),
          ),
          packagesResult: Result.success([]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load profile'), findsOneWidget);
    expect(find.text('No connection'), findsOneWidget);
  });
}

Widget _buildProfileScreen(
  ProfileRepository repository, {
  String? idOrUsername,
}) {
  return ProviderScope(
    overrides: [profileRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ProfileScreen(idOrUsername: idOrUsername)),
    ),
  );
}

const _profile = PromooProfile(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
  username: 'saffron.social',
  bio: 'Boutique campaign studio for premium launches.',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(
    followers: 185400,
    following: 124,
    services: 1,
    likes: 48600,
    posts: 28,
    views: 312000,
  ),
  mediaUrls: [
    'promoo-media://saffron-social/post-1',
    'promoo-media://saffron-social/post-2',
    'promoo-media://saffron-social/reel-3',
  ],
  isVerified: true,
);

const _profileWithoutMedia = PromooProfile(
  id: 'profile-empty-media',
  displayName: 'Empty Media Studio',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(followers: 1200),
);

const _package = ProfilePackage(
  id: 'package-1',
  title: 'Boutique launch campaign',
  description: 'Creator coverage and launch positioning.',
  price: ProfilePackagePrice(amount: 2200, currency: 'AED'),
);

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

  @override
  Future<Result<List<FollowUser>>> getFollowers(String profileId) async =>
      const Result.success(<FollowUser>[]);

  @override
  Future<Result<bool>> getBlockStatus(String profileId) async =>
      const Result.success(false);

  @override
  Future<Result<void>> blockProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<void>> unblockProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<List<FollowUser>>> getBlockedUsers() async =>
      const Result.success(<FollowUser>[]);

  @override
  Future<Result<void>> deleteAccount() async => const Result.success(null);

  @override
  Future<Result<void>> deleteMedia(String imageUrl) async =>
      const Result.success(null);
}

class _PendingProfileRepository implements ProfileRepository {
  const _PendingProfileRepository(this.completer);

  final Completer<Result<PromooProfile>> completer;

  @override
  Future<Result<void>> deleteMedia(String imageUrl) async =>
      const Result.success(null);

  @override
  Future<Result<PromooProfile>> getDemoProfile() {
    return completer.future;
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) {
    return completer.future;
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() {
    return completer.future;
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(String profileId) {
    return Future.value(const Result.success([]));
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(ProfileUpdateDraft draft) {
    return Future.value(
      const Result.failure(
        AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
      ),
    );
  }

  @override
  Future<Result<PromooProfile>> updateMyAvatar(String avatarUrl) {
    return completer.future;
  }

  @override
  Future<Result<PromooProfile>> updateMyCover(String coverUrl) {
    return completer.future;
  }

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

  @override
  Future<Result<List<FollowUser>>> getFollowers(String profileId) async =>
      const Result.success(<FollowUser>[]);

  @override
  Future<Result<bool>> getBlockStatus(String profileId) async =>
      const Result.success(false);

  @override
  Future<Result<void>> blockProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<void>> unblockProfile(String profileId) async =>
      const Result.success(null);

  @override
  Future<Result<List<FollowUser>>> getBlockedUsers() async =>
      const Result.success(<FollowUser>[]);

  @override
  Future<Result<void>> deleteAccount() async => const Result.success(null);
}
