import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('launch intro is logo-only and auto opens login', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.splash);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    final logo = tester.widget<PromooLogo>(find.byType(PromooLogo));
    expect(logo.variant, PromooLogoVariant.full);
    expect(logo.assetName, 'assets/brand/promoo3.svg');
    expect(logo.width, lessThanOrEqualTo(310));
    expect(logo.height, 160);
    expect(logo.artworkScale, 2.65);
    expect(find.text('Welcome to Promoo'), findsNothing);
    expect(find.text('Enter Promoo'), findsNothing);
    expect(find.text('Top Offers'), findsNothing);

    await tester.pump(const Duration(milliseconds: 4800));
    expect(find.byType(PromooLogo), findsOneWidget);
    expect(find.text('Login'), findsNothing);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsAtLeastNWidgets(1));
    expect(find.text('Continue as Guest'), findsOneWidget);
  });
}
