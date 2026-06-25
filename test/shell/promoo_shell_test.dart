import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('shell navigation renders main placeholder tabs', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.home);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
    );
    await tester.pumpAndSettle();

    for (final tab in ['Home', 'Services', 'Cup', 'Seats', 'Profile']) {
      expect(find.byTooltip(tab), findsOneWidget);
    }
    expect(
      find.text('Home vertical slice is not started yet.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Services'));
    await tester.pumpAndSettle();

    expect(
      find.text('Services vertical slice is not started yet.'),
      findsOneWidget,
    );
  });
}
