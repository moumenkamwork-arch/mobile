import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_environment.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.useMocks,
    this.fallbackCurrency = defaultFallbackCurrency,
  });

  static const defaultDevelopmentBaseUrl = 'http://localhost:3000/api/v1';
  static const defaultFallbackCurrency = 'AED';

  final AppEnvironment environment;
  final String baseUrl;
  final bool useMocks;
  final String fallbackCurrency;

  String get normalizedBaseUrl {
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment(
      'PROMOO_ENV',
      defaultValue: 'development',
    );
    const baseUrl = String.fromEnvironment(
      'PROMOO_BASE_URL',
      defaultValue: defaultDevelopmentBaseUrl,
    );
    const useMocks = bool.fromEnvironment(
      'PROMOO_USE_MOCKS',
      defaultValue: false,
    );
    const fallbackCurrency = String.fromEnvironment(
      'PROMOO_FALLBACK_CURRENCY',
      defaultValue: defaultFallbackCurrency,
    );

    return AppConfig(
      environment: AppEnvironment.fromName(environmentName),
      baseUrl: baseUrl,
      useMocks: useMocks,
      fallbackCurrency: fallbackCurrency,
    );
  }
}
