import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('launch intro renders and CTA opens login', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.splash);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome to Promoo'), findsOneWidget);
    expect(find.text('Enter Promoo'), findsOneWidget);

    await tester.tap(find.text('Enter Promoo'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsAtLeastNWidgets(1));
    expect(find.text('Sign in to access your Promoo actions.'), findsOneWidget);
  });
}
