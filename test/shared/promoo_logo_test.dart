import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('PromooLogo renders the configured SVG asset', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Center(child: PromooLogo.full(width: 180, height: 120)),
        ),
      ),
    );

    expect(find.byType(PromooLogo), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
