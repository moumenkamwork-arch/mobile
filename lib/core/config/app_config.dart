import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

/// App-wide configuration: the API base URL plus small display defaults.
///
/// There is deliberately no `environment`/`useMocks` toggle here (unlike the
/// pre-integration build): each feature switches from its fake data source to
/// its remote one individually as its wiring phase lands (see
/// `docs/integration_map.md`), so a single global mock flag would no longer
/// mean anything once some features are wired and others aren't.
class AppConfig {
  const AppConfig({
    this.baseUrl = defaultBaseUrl,
    this.fallbackCurrency = defaultFallbackCurrency,
    this.supabaseUrl = defaultSupabaseUrl,
    this.supabaseAnonKey = defaultSupabaseAnonKey,
  });

  static const defaultBaseUrl = 'http://localhost:3000/api/v1';
  static const defaultFallbackCurrency = 'AED';
  // The anon key is meant to be public/client-embeddable — Row Level
  // Security on the underlying tables is the real access boundary (already
  // scoped correctly for `messages`/`chat_rooms`/`chat_participants`).
  // `.env` (SUPABASE_URL/SUPABASE_ANON_KEY) is still the priority source —
  // see fromEnvironment() below — this is only the safety-net fallback if
  // .env somehow isn't bundled/loaded, so Realtime never silently points at
  // an empty URL.
  static const defaultSupabaseUrl = 'https://mqklargyjispbcyxzdjo.supabase.co';
  static const defaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xa2xhcmd5amlzcGJjeXh6ZGpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2MjQ3NzUsImV4cCI6MjA5NzIwMDc3NX0.fJOsJy5AK5Uvn8SR-P6ajqtd1h4osNE8vlJ1XrFWXFI';

  final String baseUrl;
  final String fallbackCurrency;
  final String supabaseUrl;
  final String supabaseAnonKey;

  String get normalizedBaseUrl {
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  /// Priority: `.env` (via `flutter_dotenv`, loaded in `main()`) > `--dart-define`
  /// (for CI/build-time overrides where bundling a `.env` isn't practical) >
  /// the hardcoded dev default. `--dart-define` reads must stay literal
  /// compile-time consts (Dart requirement), so each is inlined here rather
  /// than going through a shared helper.
  factory AppConfig.fromEnvironment() {
    const defineBaseUrl = String.fromEnvironment(
      'PROMOO_BASE_URL',
      defaultValue: defaultBaseUrl,
    );
    const defineFallbackCurrency = String.fromEnvironment(
      'PROMOO_FALLBACK_CURRENCY',
      defaultValue: defaultFallbackCurrency,
    );
    const defineSupabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: defaultSupabaseUrl,
    );
    const defineSupabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: defaultSupabaseAnonKey,
    );

    return AppConfig(
      baseUrl: _dotenvGet('PROMOO_BASE_URL') ?? defineBaseUrl,
      fallbackCurrency:
          _dotenvGet('PROMOO_FALLBACK_CURRENCY') ?? defineFallbackCurrency,
      supabaseUrl: _dotenvGet('SUPABASE_URL') ?? defineSupabaseUrl,
      supabaseAnonKey: _dotenvGet('SUPABASE_ANON_KEY') ?? defineSupabaseAnonKey,
    );
  }

  /// `dotenv.maybeGet` throws if `.load()` was never called — true for every
  /// test, since none of them boot through `main()`. Treat "not loaded" the
  /// same as "key not present": fall through to the next source.
  static String? _dotenvGet(String key) {
    try {
      return dotenv.maybeGet(key);
    } catch (_) {
      return null;
    }
  }
}
