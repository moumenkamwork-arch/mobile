import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/network/api_response.dart';

void main() {
  test('parses success envelope with data and meta', () {
    final response = ApiResponse<Map<String, Object?>>.parse({
      'success': true,
      'message': 'ok',
      'data': {'id': 'home'},
      'meta': {'page': 1},
    });

    expect(response.success, isTrue);
    expect(response.message, 'ok');
    expect(response.data, {'id': 'home'});
    expect(response.meta, {'page': 1});
    expect(response.error, isNull);
  });

  test('parses error envelope without data', () {
    final response = ApiResponse<Map<String, Object?>>.parse({
      'success': false,
      'message': 'Invalid request',
      'data': null,
      'error': {
        'code': 'VALIDATION_ERROR',
        'details': ['name is required'],
      },
    });

    expect(response.success, isFalse);
    expect(response.message, 'Invalid request');
    expect(response.data, isNull);
    expect(response.error?.code, 'VALIDATION_ERROR');
    expect(response.error?.details, ['name is required']);
  });

  test('parses direct non-envelope object', () {
    final response = ApiResponse<Map<String, Object?>>.parse({
      'id': 'service-1',
      'title': 'Design',
    });

    expect(response.success, isTrue);
    expect(response.data, {'id': 'service-1', 'title': 'Design'});
  });
}
