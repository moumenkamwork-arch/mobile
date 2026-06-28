import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('shell navigation renders main tabs', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.profile);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
    );
    await tester.pumpAndSettle();

    for (final tab in ['Home', 'Services', 'Cup', 'Influencer', 'Profile']) {
      expect(find.byTooltip(tab), findsOneWidget);
    }
    expect(find.text('Saffron Social Studio'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Packages'), findsOneWidget);
  });
}
