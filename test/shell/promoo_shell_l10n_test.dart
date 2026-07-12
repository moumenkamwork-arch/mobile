import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'shell tabs and header render Arabic text but stay LTR (no mirrored layout)',
    (tester) async {
      final router = createAppRouter(initialLocation: AppRoutes.home);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: AppTheme.dark,
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Mirrors lib/app.dart: translate, don't mirror the layout.
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Bottom-nav tabs (L1: promoo_shell).
      for (final tab in [
        'الرئيسية',
        'المؤثرون',
        'بروموو',
        'الخدمات',
        'حسابي',
      ]) {
        expect(find.byTooltip(tab), findsOneWidget);
      }

      // Header actions (L1: promoo_page_header).
      expect(find.byTooltip('المحادثات'), findsOneWidget);
      expect(find.byTooltip('التنبيهات'), findsOneWidget);
      expect(find.byTooltip('التبديل للوضع الفاتح'), findsOneWidget);

      // The whole shell (chrome + content) stays LTR even with Arabic text.
      expect(
        Directionality.of(tester.element(find.byTooltip('الرئيسية'))),
        TextDirection.ltr,
      );
    },
  );
}
