import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// App theme mode (Black = dark, Light = light). Promoo is a dark-first brand,
/// so the default is [ThemeMode.dark].
///
/// The choice is persisted on-device (best effort) so it survives restarts.
/// Storage errors are swallowed: on platforms/tests without the plugin the
/// controller simply behaves as before (in-memory only).
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _storageKey = 'promoo_theme_mode';
  static const _storage = FlutterSecureStorage();

  @override
  ThemeMode build() {
    unawaited(_restore());
    return ThemeMode.dark;
  }

  Future<void> _restore() async {
    try {
      final saved = await _storage.read(key: _storageKey);
      if (saved == 'light') {
        state = ThemeMode.light;
      }
    } catch (_) {
      // Best effort — keep the dark default.
    }
  }

  void setDark() {
    state = ThemeMode.dark;
    unawaited(_persist('dark'));
  }

  void setLight() {
    state = ThemeMode.light;
    unawaited(_persist('light'));
  }

  bool get isDark => state == ThemeMode.dark;

  Future<void> _persist(String value) async {
    try {
      await _storage.write(key: _storageKey, value: value);
    } catch (_) {
      // Best effort — the in-memory state is already updated.
    }
  }
}
