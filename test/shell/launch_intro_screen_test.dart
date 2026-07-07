import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'launch intro reveals Promoo letter by letter and auto opens login',
    (tester) async {
      final router = createAppRouter(initialLocation: AppRoutes.splash);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.bySemanticsLabel('Promoo intro'), findsOneWidget);
      expect(find.text('Welcome to Promoo'), findsNothing);
      expect(find.text('Top Offers'), findsNothing);
      expect(find.text('Login'), findsNothing);

      await tester.pump(const Duration(milliseconds: 1400));
      expect(find.text('P'), findsOneWidget);
      expect(find.text('r'), findsOneWidget);
      expect(find.text('m'), findsOneWidget);
      expect(find.text('o'), findsNWidgets(3));

      await tester.pump(const Duration(milliseconds: 1400));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsAtLeastNWidgets(1));
      expect(find.text('Continue as Guest'), findsOneWidget);
    },
  );
}
