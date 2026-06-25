import 'package:dio/dio.dart';

import 'api_response.dart';

enum ApiExceptionType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimit,
  server,
  parsing,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  final ApiExceptionType type;
  final String message;
  final int? statusCode;
  final String? code;
  final List<Object?>? details;

  factory ApiException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          type: ApiExceptionType.timeout,
          message: 'The request timed out.',
        );
      case DioExceptionType.badResponse:
        return ApiException.fromResponse(exception.response);
      case DioExceptionType.connectionError:
        return const ApiException(
          type: ApiExceptionType.network,
          message: 'A network connection error occurred.',
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          type: ApiExceptionType.network,
          message: 'A secure connection could not be established.',
        );
      case DioExceptionType.cancel:
        return const ApiException(
          type: ApiExceptionType.unknown,
          message: 'The request was cancelled.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          type: ApiExceptionType.unknown,
          message: exception.message ?? 'An unknown network error occurred.',
        );
    }
  }

  factory ApiException.fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final body = response?.data;
    final error = ApiError.fromBody(body);
    final message = _messageFromBody(body) ?? _messageForStatus(statusCode);

    return ApiException(
      type: _typeForStatus(statusCode),
      message: message,
      statusCode: statusCode,
      code: error?.code,
      details: error?.details,
    );
  }

  const ApiException.parsing([
    String message = 'Failed to parse the server response.',
  ]) : this(type: ApiExceptionType.parsing, message: message);

  static ApiExceptionType _typeForStatus(int? statusCode) {
    if (statusCode == null) {
      return ApiExceptionType.unknown;
    }

    return switch (statusCode) {
      401 => ApiExceptionType.unauthorized,
      403 => ApiExceptionType.forbidden,
      404 => ApiExceptionType.notFound,
      422 || 400 => ApiExceptionType.validation,
      429 => ApiExceptionType.rateLimit,
      >= 500 => ApiExceptionType.server,
      _ => ApiExceptionType.unknown,
    };
  }

  static String _messageForStatus(int? statusCode) {
    if (statusCode == null) {
      return 'Something went wrong. Try again.';
    }

    return switch (statusCode) {
      401 => 'Please sign in to continue.',
      403 => 'You do not have permission to do that.',
      404 => 'The requested item was not found.',
      422 || 400 => 'Check the details and try again.',
      429 => 'Too many requests. Try again later.',
      >= 500 => 'Something went wrong on our side.',
      _ => 'Something went wrong. Try again.',
    };
  }

  static String? _messageFromBody(Object? body) {
    if (body case {'message': final String message} when message.isNotEmpty) {
      return message;
    }
    if (body case {
      'error': {'message': final String message},
    } when message.isNotEmpty) {
      return message;
    }
    return null;
  }

  @override
  String toString() {
    final codeText = code == null ? '' : ' code=$code';
    final statusText = statusCode == null ? '' : ' status=$statusCode';
    return 'ApiException(${type.name}$statusText$codeText): $message';
  }
}
