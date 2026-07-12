import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'i18n/locale_controller.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';

class PromooApp extends ConsumerWidget {
  const PromooApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Promoo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Owner decision (2026-07-11): translate text to Arabic but keep the
      // LAYOUT direction fixed LTR in both languages — no mirrored UI. Flutter
      // derives Directionality from the locale by default (ar -> rtl), so we
      // force it back to ltr here regardless of `locale`. Arabic text still
      // renders correctly right-to-left at the glyph level (that's the
      // Unicode bidi algorithm inside each Text run, independent of this
      // layout-direction override) — only widget layout (Row order, start/end
      // padding resolution, alignment) stays LTR.
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
    );
  }
}
