import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promoo_app/app.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';

void main() {
  testWidgets('builds the Promoo app root', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PromooApp()));

    expect(find.byType(PromooLogo), findsOneWidget);
    expect(find.text('Design system shell'), findsOneWidget);
    expect(find.text('Preview app shell'), findsOneWidget);
  });
}
