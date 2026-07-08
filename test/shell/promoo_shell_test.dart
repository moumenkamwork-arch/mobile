import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('shell renders main tabs and the Profile menu page', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.profile);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    for (final tab in ['Home', 'Services', 'Cup', 'Influencer', 'Profile']) {
      expect(find.byTooltip(tab), findsOneWidget);
    }

    // Profile tab shows the settings-style menu page (no modal sheet).
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Profile Management'), findsOneWidget);
    expect(find.text('Add New Offer'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Language'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('MyPackages'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('PrivacyPolicy'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('TermsAndCondition'), findsOneWidget);
    expect(find.text('PrivacyPolicy'), findsOneWidget);

    // Profile Management opens the Edit Profile page.
    await tester.scrollUntilVisible(
      find.text('Profile Management'),
      -260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile Management'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Change profile photo'), findsOneWidget);
  });
}
