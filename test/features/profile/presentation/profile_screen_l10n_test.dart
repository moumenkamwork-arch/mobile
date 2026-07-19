import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/profile/domain/entities/follow_user.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'profile screen renders Arabic stats and account type, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(
              const _ProfileRepository(),
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
            home: const Scaffold(body: ProfileScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fixture display name stays untranslated demo content.
      expect(find.text('Saffron Social Studio'), findsOneWidget);
      // Stats row labels are translated.
      expect(find.text('المتابعون'), findsOneWidget);
      expect(find.text('الإعجابات'), findsOneWidget);
      expect(find.text('المنشورات'), findsOneWidget);
      expect(find.text('المشاهدات'), findsOneWidget);
      // Account-type meta chip reuses the Auth feature's Arabic label.
      expect(find.text('شركة'), findsOneWidget);
      // Owner view shows the translated Edit profile action.
      expect(find.text('تعديل الملف الشخصي'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('الباقات'),
        260,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('الباقات'), findsAtLeastNWidgets(1));

      expect(
        Directionality.of(tester.element(find.text('الباقات').first)),
        TextDirection.ltr,
      );
    },
  );
}

class _ProfileRepository implements ProfileRepository {
  const _ProfileRepository();

  static const _profile = PromooProfile(
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
    isVerified: true,
  );

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    return const Result.success(_profile);
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    return const Result.success(_profile);
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    return const Result.success(_profile);
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(
    String profileId,
  ) async {
    return const Result.success([
      ProfilePackage(
        id: 'package-1',
        title: 'Boutique launch campaign',
        price: ProfilePackagePrice(amount: 2200, currency: 'AED'),
      ),
    ]);
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(
    ProfileUpdateDraft draft,
  ) async {
    return const Result.success(_profile);
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
}
