import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';

void main() {
  test('fromEnvironment uses the core defaultBaseUrl', () {
    final config = AppConfig.fromEnvironment();

    expect(config.baseUrl, AppConfig.defaultBaseUrl);
    expect(config.normalizedBaseUrl, AppConfig.defaultBaseUrl);
    expect(config.fallbackCurrency, AppConfig.defaultFallbackCurrency);
  });

  test('normalizedBaseUrl removes a trailing slash', () {
    const config = AppConfig(baseUrl: 'https://api.example.com/api/v1/');

    expect(config.normalizedBaseUrl, 'https://api.example.com/api/v1');
  });
}
