import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App theme mode (Black = dark, Light = light). Promoo is a dark-first brand,
/// so the default is [ThemeMode.dark]. Frontend-only; not persisted yet.
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setDark() => state = ThemeMode.dark;

  void setLight() => state = ThemeMode.light;

  bool get isDark => state == ThemeMode.dark;
}
