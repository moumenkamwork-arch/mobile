import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

/// App-wide UI configuration.
///
/// The network config (base URL, environment, `useMocks` toggle) was removed
/// when the app was reset to a pure frontend build: there is no backend
/// wiring anymore — every repository serves local data. Integration will be
/// re-introduced later, feature by feature (see `docs/integration_map.md`).
/// Only the display-currency fallback remains.
class AppConfig {
  const AppConfig({this.fallbackCurrency = defaultFallbackCurrency});

  static const defaultFallbackCurrency = 'AED';

  final String fallbackCurrency;

  factory AppConfig.fromEnvironment() {
    const fallbackCurrency = String.fromEnvironment(
      'PROMOO_FALLBACK_CURRENCY',
      defaultValue: defaultFallbackCurrency,
    );
    return const AppConfig(fallbackCurrency: fallbackCurrency);
  }
}
