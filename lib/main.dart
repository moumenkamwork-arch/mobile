import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Best-effort: a missing .env (e.g. a fresh checkout before copying
  // .env.example) falls back to --dart-define / the hardcoded dev defaults
  // in AppConfig, so this must never crash app start.
  try {
    await dotenv.load();
  } catch (_) {
    // No .env bundled — AppConfig.fromEnvironment() falls back below.
  }

  final appConfig = AppConfig.fromEnvironment();

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(appConfig)],
      child: const PromooApp(),
    ),
  );
}
