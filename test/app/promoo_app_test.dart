import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promoo_app/app.dart';

void main() {
  testWidgets('builds the Promoo app root', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PromooApp()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.bySemanticsLabel('Promoo intro'), findsOneWidget);
    expect(find.text('Welcome to Promoo'), findsNothing);
    expect(find.text('Enter Promoo'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1400));
    expect(find.bySemanticsLabel('Promoo intro'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();

    expect(find.text('Continue as Guest'), findsOneWidget);
  });
}
