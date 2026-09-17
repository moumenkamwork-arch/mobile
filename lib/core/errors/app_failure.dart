enum AppFailureType {
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

class AppFailure {
  const AppFailure({
    required this.type,
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  final AppFailureType type;
  final String message;
  final String? code;
  final int? statusCode;
  final List<Object?>? details;

  const AppFailure.network({
    String message = 'Check your connection and try again.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.network,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.timeout({
    String message = 'The request timed out. Try again.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.timeout,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.unauthorized({
    String message = 'Please sign in to continue.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.unauthorized,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.forbidden({
    String message = 'You do not have permission to do that.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.forbidden,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.notFound({
    String message = 'The requested item was not found.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.notFound,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.validation({
    String message = 'Check the details and try again.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.validation,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.rateLimit({
    String message = 'Too many requests. Try again later.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.rateLimit,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.server({
    String message = 'Something went wrong on our side.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.server,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.parsing({
    String message = 'We could not read the server response.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.parsing,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  const AppFailure.unknown({
    String message = 'Something went wrong. Try again.',
    String? code,
    int? statusCode,
    List<Object?>? details,
  }) : this(
         type: AppFailureType.unknown,
         message: message,
         code: code,
         statusCode: statusCode,
         details: details,
       );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppFailure &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            message == other.message &&
            code == other.code &&
            statusCode == other.statusCode &&
            _listEquals(details, other.details);
  }

  @override
  int get hashCode => Object.hash(
    type,
    message,
    code,
    statusCode,
    Object.hashAll(details ?? const []),
  );

  static bool _listEquals(List<Object?>? a, List<Object?>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null || a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
