import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';

void main() {
  test('fromEnvironment uses development defaults', () {
    final config = AppConfig.fromEnvironment();

    expect(config.environment, AppEnvironment.development);
    expect(config.baseUrl, AppConfig.defaultDevelopmentBaseUrl);
    expect(config.normalizedBaseUrl, AppConfig.defaultDevelopmentBaseUrl);
    expect(config.useMocks, isFalse);
  });

  test('normalizedBaseUrl removes trailing slash', () {
    const config = AppConfig(
      environment: AppEnvironment.staging,
      baseUrl: 'https://api.example.com/api/v1/',
      useMocks: true,
    );

    expect(config.normalizedBaseUrl, 'https://api.example.com/api/v1');
  });
}
