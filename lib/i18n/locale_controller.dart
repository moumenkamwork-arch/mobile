import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// App locale — English or Arabic (with RTL). On first run it follows the
/// device locale (Arabic if the device is Arabic, otherwise English); after
/// that the user's explicit choice is persisted on-device.
///
/// Mirrors [ThemeModeController]: storage is best-effort, so on platforms/tests
/// without the plugin the controller simply stays in-memory. This is the single
/// source of truth for the app locale — the Phase B network client will read it
/// to set the `Accept-Language` header.
final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

/// Locales the app ships translations for.
const supportedAppLocales = [Locale('en'), Locale('ar')];

class LocaleController extends Notifier<Locale> {
  static const _storageKey = 'promoo_locale';
  static const _storage = FlutterSecureStorage();

  @override
  Locale build() {
    unawaited(_restore());
    return _deviceDefault();
  }

  static Locale _deviceDefault() {
    final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return code == 'ar' ? const Locale('ar') : const Locale('en');
  }

  Future<void> _restore() async {
    try {
      final saved = await _storage.read(key: _storageKey);
      if (saved == 'ar') {
        state = const Locale('ar');
      } else if (saved == 'en') {
        state = const Locale('en');
      }
    } catch (_) {
      // Best effort — keep the device default.
    }
  }

  void setArabic() {
    state = const Locale('ar');
    unawaited(_persist('ar'));
  }

  void setEnglish() {
    state = const Locale('en');
    unawaited(_persist('en'));
  }

  bool get isArabic => state.languageCode == 'ar';

  Future<void> _persist(String value) async {
    try {
      await _storage.write(key: _storageKey, value: value);
    } catch (_) {
      // Best effort — the in-memory state is already updated.
    }
  }
}
