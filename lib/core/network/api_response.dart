class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.data,
    this.message,
    this.meta,
    this.error,
  });

  final bool success;
  final T? data;
  final String? message;
  final Map<String, Object?>? meta;
  final ApiError? error;

  factory ApiResponse.parse(Object? body, {T Function(Object? data)? decode}) {
    if (body is Map<String, Object?>) {
      return _parseMap(body, decode: decode);
    }
    if (body is Map) {
      return _parseMap(Map<String, Object?>.from(body), decode: decode);
    }

    return ApiResponse<T>(success: true, data: _decodeData(body, decode));
  }

  static ApiResponse<T> _parseMap<T>(
    Map<String, Object?> body, {
    T Function(Object? data)? decode,
  }) {
    final hasEnvelope =
        body.containsKey('success') ||
        body.containsKey('data') ||
        body.containsKey('meta') ||
        body.containsKey('error') ||
        body.containsKey('message');
    final success = body['success'] is bool
        ? body['success']! as bool
        : body['error'] == null;
    final dataValue = hasEnvelope ? body['data'] : body;
    final meta = _mapFrom(body['meta']);
    final message = body['message'] is String
        ? body['message']! as String
        : null;
    final error = ApiError.fromBody(body);

    return ApiResponse<T>(
      success: success,
      data: success ? _decodeData(dataValue, decode) : null,
      message: message,
      meta: meta,
      error: error,
    );
  }

  static T? _decodeData<T>(Object? data, T Function(Object? data)? decode) {
    if (decode != null) {
      return decode(data);
    }
    if (data == null) {
      return null;
    }
    if (data is T) {
      return data as T;
    }
    throw FormatException(
      'Expected response data of type $T but received ${data.runtimeType}.',
    );
  }

  static Map<String, Object?>? _mapFrom(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return Map<String, Object?>.from(value);
    }
    return null;
  }
}

class ApiError {
  const ApiError({this.code, this.details});

  final String? code;
  final List<Object?>? details;

  static ApiError? fromBody(Object? body) {
    if (body is! Map) {
      return null;
    }

    final rawError = body['error'];
    if (rawError is Map) {
      return ApiError(
        code: rawError['code'] is String ? rawError['code']! as String : null,
        details: rawError['details'] is List
            ? List<Object?>.from(rawError['details']! as List)
            : null,
      );
    }

    return null;
  }
}
