import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'core/auth/session_expiry_signal.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/chat/data/realtime/chat_realtime_service.dart';
import 'features/notifications/data/realtime/notifications_realtime_service.dart';
import 'i18n/locale_controller.dart';
import 'routing/app_router.dart';
import 'routing/route_names.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';
import 'core/push/push_notification_service.dart';

class PromooApp extends ConsumerStatefulWidget {
  const PromooApp({super.key});

  @override
  ConsumerState<PromooApp> createState() => _PromooAppState();
}

class _PromooAppState extends ConsumerState<PromooApp>
    with WidgetsBindingObserver {
  final ShorebirdUpdater _shorebirdUpdater = ShorebirdUpdater();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkShorebirdUpdateInBackground();
  }

  Future<void> _checkShorebirdUpdateInBackground() async {
    if (!_shorebirdUpdater.isAvailable) return;

    try {
      final status = await _shorebirdUpdater.checkForUpdate();
      if (status != UpdateStatus.outdated) return;

      await _shorebirdUpdater.update();
    } on Object catch (e) {
      debugPrint('Shorebird update check failed: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A backgrounded app's realtime socket is often silently killed or
    // stalled by the OS without either side ever firing a close event —
    // resuming is the one moment worth actively checking rather than
    // waiting on the library's own heartbeat to notice.
    if (state == AppLifecycleState.resumed) {
      ref.read(chatRealtimeServiceProvider).ensureConnected();
      ref.read(notificationsRealtimeServiceProvider).ensureConnected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Expired-session guard: when the network layer gives up refreshing a dead
    // token it bumps this signal. Flip auth to signed-out and bounce to Login
    // so the app can't get stuck showing authed screens whose every request
    // 401s (the "I was on Home but everything was broken until I signed out"
    // bug).
    ref.listen<int>(sessionExpiredSignalProvider, (previous, next) {
      if (next > (previous ?? 0)) {
        ref.read(authControllerProvider.notifier).onSessionExpired();
        router.go(AppRoutes.login);
      }
    });

    // Watch the service to keep it alive and listening to auth changes.
    // Null when Firebase didn't initialize (see push_notification_service.dart).
    final pushService = ref.watch(pushNotificationServiceProvider);

    // Initialize once
    if (pushService != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pushService.init();
      });
    }

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
