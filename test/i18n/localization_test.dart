import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/i18n/locale_controller.dart';
import 'package:promoo_app/l10n/app_localizations.dart';

/// Mirrors the real `builder` override in `lib/app.dart`: translate text, but
/// keep the LAYOUT direction fixed LTR regardless of locale (owner decision
/// 2026-07-11 — no mirrored UI when switching to Arabic).
Widget _localizedProbe(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(body: Text(l10n.settingsLanguage));
      },
    ),
  );
}

void main() {
  testWidgets('English locale renders English strings and LTR', (tester) async {
    await tester.pumpWidget(_localizedProbe(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Language'))),
      TextDirection.ltr,
    );
  });

  testWidgets(
    'Arabic locale renders Arabic strings but stays LTR (no mirrored layout)',
    (tester) async {
      await tester.pumpWidget(_localizedProbe(const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('اللغة'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('اللغة'))),
        TextDirection.ltr,
      );
    },
  );

  test('LocaleController toggles English/Arabic', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Reading it builds the controller (device default in the test env).
    final initial = container.read(localeProvider).languageCode;
    expect(initial, anyOf('en', 'ar'));

    container.read(localeProvider.notifier).setArabic();
    expect(container.read(localeProvider).languageCode, 'ar');
    expect(container.read(localeProvider.notifier).isArabic, isTrue);

    container.read(localeProvider.notifier).setEnglish();
    expect(container.read(localeProvider).languageCode, 'en');
    expect(container.read(localeProvider.notifier).isArabic, isFalse);
  });
}
