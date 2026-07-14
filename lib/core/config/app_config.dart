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
  });

  static const defaultBaseUrl = 'http://localhost:3000/api/v1';
  static const defaultFallbackCurrency = 'AED';

  final String baseUrl;
  final String fallbackCurrency;

  String get normalizedBaseUrl {
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  factory AppConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'PROMOO_BASE_URL',
      defaultValue: defaultBaseUrl,
    );
    const fallbackCurrency = String.fromEnvironment(
      'PROMOO_FALLBACK_CURRENCY',
      defaultValue: defaultFallbackCurrency,
    );
    return const AppConfig(baseUrl: baseUrl, fallbackCurrency: fallbackCurrency);
  }
}
