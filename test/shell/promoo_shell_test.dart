import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
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
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Footer order per owner request: the center P mark now leads to the Cup
    // page and is labelled "Promoo"; Services is a normal tab.
    for (final tab in ['Home', 'Influencer', 'Promoo', 'Services', 'Profile']) {
      expect(find.byTooltip(tab), findsOneWidget);
    }

    // Profile tab shows the settings-style menu page (no modal sheet).
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Profile Management'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    // Creation rows are role-gated: a guest (no session) can create nothing,
    // so none of Add New Offer/Ad/Service appear (mirrors backend 403 guards).
    expect(find.text('Add New Offer'), findsNothing);
    expect(find.text('Add New Ad'), findsNothing);
    expect(find.text('Add New Service'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Language'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('My Packages'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Privacy Policy'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);

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
