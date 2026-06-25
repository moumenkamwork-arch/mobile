import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/shared/widgets/promoo_empty_state.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('PromooLoadingIndicator builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: PromooLoadingIndicator(message: 'Loading content'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading content'), findsOneWidget);
  });

  testWidgets('PromooEmptyState builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: PromooEmptyState(
            title: 'Nothing here yet',
            message: 'This state is ready for future slices.',
            actionLabel: 'Refresh',
            onActionPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Nothing here yet'), findsOneWidget);
    expect(find.text('This state is ready for future slices.'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });

  testWidgets('PromooErrorState builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: PromooErrorState(
            title: 'Something went wrong',
            message: 'Try again in a moment.',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Try again in a moment.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
