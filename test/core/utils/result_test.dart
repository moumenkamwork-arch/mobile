import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';

void main() {
  test('success exposes data through when', () {
    const result = Result<int>.success(7);

    expect(result.isSuccess, isTrue);
    expect(result.isFailure, isFalse);
    expect(result.when(success: (data) => data * 2, failure: (_) => 0), 14);
  });

  test('failure exposes AppFailure through when', () {
    const failure = AppFailure.timeout();
    const result = Result<int>.failure(failure);

    expect(result.isSuccess, isFalse);
    expect(result.isFailure, isTrue);
    expect(
      result.when(success: (_) => 'success', failure: (error) => error.message),
      failure.message,
    );
  });

  test('result values compare by content', () {
    expect(const Result<int>.success(1), const Result<int>.success(1));
    expect(
      const Result<int>.failure(AppFailure.network()),
      const Result<int>.failure(AppFailure.network()),
    );
  });
}
