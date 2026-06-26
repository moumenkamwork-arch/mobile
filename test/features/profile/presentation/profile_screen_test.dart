import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/features/profile/presentation/screens/profile_screen.dart';
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

  testWidgets('renders profile and safe actions', (tester) async {
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

    expect(find.text('Noura Studio'), findsOneWidget);
    expect(find.text('@noura.studio'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();
    expect(find.text('Login required'), findsOneWidget);

    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Message'));
    await tester.pumpAndSettle();
    expect(find.text('Chats are ready'), findsOneWidget);
    expect(find.text('Open chats'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Media'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Media'), findsOneWidget);
    expect(find.text('Post 1'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Profile tools'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile tools'), findsOneWidget);

    await tester.tap(find.text('Manage profile'));
    await tester.pumpAndSettle();

    expect(find.text('Manage profile coming soon'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Packages'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Packages'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Content package'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Content package'), findsOneWidget);
    expect(find.text('750 AED'), findsOneWidget);
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
        idOrUsername: 'noura.studio',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Noura Studio'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Content package'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile tools'), findsNothing);
    expect(find.text('Content package'), findsOneWidget);
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
      home: Scaffold(body: ProfileScreen(idOrUsername: idOrUsername)),
    ),
  );
}

const _profile = PromooProfile(
  id: 'profile-demo',
  displayName: 'Noura Studio',
  username: 'noura.studio',
  bio: 'Premium content studio.',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(followers: 185400, following: 124, services: 1),
  mediaUrls: [
    'mock://profile-demo/post-1',
    'mock://profile-demo/post-2',
    'mock://profile-demo/reel-3',
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
  title: 'Content package',
  description: 'Campaign content.',
  price: ProfilePackagePrice(amount: 750, currency: 'AED'),
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
}

class _PendingProfileRepository implements ProfileRepository {
  const _PendingProfileRepository(this.completer);

  final Completer<Result<PromooProfile>> completer;

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
}
