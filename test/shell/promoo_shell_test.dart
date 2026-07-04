import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('shell navigation renders main tabs', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.profile);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    for (final tab in ['Home', 'Services', 'Promoo', 'Influencer', 'Profile']) {
      expect(find.byTooltip(tab), findsOneWidget);
    }
    expect(find.text('Saffron Social Studio'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile menu'), findsOneWidget);
    expect(find.text('View Profile'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('Black Mode'), findsOneWidget);
    expect(find.text('Light Mode'), findsOneWidget);

    await tester.tap(find.text('Light Mode'));
    await tester.pumpAndSettle();

    expect(
      find.text('Theme options will be available in the next phase.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Follow'), findsNothing);
    expect(find.text('Message'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Packages'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Packages'), findsOneWidget);
  });
}
