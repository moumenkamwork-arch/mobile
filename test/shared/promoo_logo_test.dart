import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('PromooLogo renders the configured brand image asset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Center(child: PromooLogo.full(width: 180, height: 120)),
        ),
      ),
    );

    expect(find.byType(PromooLogo), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('full logo picks the dark-theme wordmark asset', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Center(child: PromooLogo.full(width: 180, height: 120)),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/brand/new_logo/promoo_wordmark.png',
    );
  });

  testWidgets('full logo picks the light-theme wordmark asset', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: PromooLogo.full(width: 180, height: 120)),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/brand/new_logo/promoo_wordmark_light.png',
    );
  });

  testWidgets('compact logo always uses the brand P mark asset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: PromooLogo.compact(width: 40, height: 40)),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/brand/new_logo/promoo_mark.png',
    );
  });

  test('fullCropped is flagged to crop the artwork', () {
    expect(PromooLogo.fullCropped().cropToArtwork, isTrue);
  });
}
