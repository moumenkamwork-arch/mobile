import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/session/auth_session_store.dart';
import '../../features/auth/domain/entities/auth_session.dart';
import '../../i18n/locale_controller.dart';
import '../auth/session_expiry_signal.dart';
import '../config/app_config.dart';
import '../errors/app_failure.dart';
import 'api_response.dart';

/// Kept local instead of in a shared `ApiEndpoints` (that file doesn't exist
/// yet — it lands with the first real remote data source in Phase 2) since
/// the refresh interceptor is the only Phase-1 code that needs a path.
const _refreshPath = '/auth/refresh';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.normalizedBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: const {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    ),
  );

  // Queued so concurrent 401s don't each fire their own refresh call — the
  // first one refreshes and persists new tokens, the rest simply queue
  // behind it in-order.
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = (await sessionStore.read())?.tokens?.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Accept-Language'] = ref.read(localeProvider).languageCode;
        handler.next(options);
      },
      onError: (error, handler) async {
        final alreadyRetried = error.requestOptions.extra['promooRetried'] == true;
        final isRefreshCall = error.requestOptions.path == _refreshPath;
        if (error.response?.statusCode != 401 || alreadyRetried || isRefreshCall) {
          return handler.next(error);
        }

        final session = await sessionStore.read();
        final refreshToken = session?.tokens?.refreshToken;
        if (session == null || refreshToken == null || refreshToken.isEmpty) {
          return handler.next(error);
        }

        try {
          // A bare Dio with no interceptors — avoids recursing back into
          // this same onError if the refresh call itself ever 401s.
          final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
          final response = await refreshDio.post<Object?>(
            _refreshPath,
            data: {'refresh_token': refreshToken},
          );
          final newTokens = _extractRefreshedTokens(response.data);
          if (newTokens == null) {
            await sessionStore.clear();
            ref.read(sessionExpiredSignalProvider.notifier).trigger();
            return handler.next(error);
          }

          await sessionStore.write(
            AuthSession(
              user: session.user,
              tokens: newTokens,
              requiresVerification: session.requiresVerification,
            ),
          );

          final retryOptions = error.requestOptions
            ..headers['Authorization'] = 'Bearer ${newTokens.accessToken}'
            ..extra['promooRetried'] = true;
          final retryResponse = await dio.fetch<Object?>(retryOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          await sessionStore.clear();
          ref.read(sessionExpiredSignalProvider.notifier).trigger();
          return handler.next(error);
        }
      },
    ),
  );

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: _options(headers),
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.put<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.patch<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.delete<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> _request<T>(
    Future<Response<Object?>> Function() send, {
    T Function(Object? data)? decode,
  }) async {
    try {
      final response = await send();
      final parsed = ApiResponse<T>.parse(response.data, decode: decode);

      if (!parsed.success) {
        throw AppFailure(
          type: AppFailureType.unknown,
          message: parsed.message ?? 'The request failed.',
          statusCode: response.statusCode,
          code: parsed.error?.code,
          details: parsed.error?.details,
        );
      }

      return parsed;
    } on DioException catch (error) {
      throw _failureFromDioException(error);
    } on FormatException catch (error) {
      throw AppFailure.parsing(message: error.message);
    }
  }

  Options? _options(Map<String, Object?>? headers) {
    if (headers == null || headers.isEmpty) {
      return null;
    }

    return Options(headers: headers);
  }
}

AppFailure _failureFromDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const AppFailure.timeout();
    case DioExceptionType.badResponse:
      return _failureFromResponse(exception.response);
    case DioExceptionType.connectionError:
      return const AppFailure.network();
    case DioExceptionType.badCertificate:
      return const AppFailure.network(
        message: 'A secure connection could not be established.',
      );
    case DioExceptionType.cancel:
      return const AppFailure.unknown(message: 'The request was cancelled.');
    case DioExceptionType.unknown:
    default:
      return AppFailure.unknown(
        message: exception.message ?? 'An unknown network error occurred.',
      );
  }
}

AppFailure _failureFromResponse(Response<Object?>? response) {
  final statusCode = response?.statusCode;
  final body = response?.data;
  final error = ApiError.fromBody(body);
  final type = _typeForStatus(statusCode);

  return AppFailure(
    type: type,
    message: _messageFromBody(body) ?? _defaultMessageFor(type),
    code: error?.code,
    statusCode: statusCode,
    details: error?.details,
  );
}

AppFailureType _typeForStatus(int? statusCode) {
  if (statusCode == null) {
    return AppFailureType.unknown;
  }

  return switch (statusCode) {
    401 => AppFailureType.unauthorized,
    403 => AppFailureType.forbidden,
    404 => AppFailureType.notFound,
    422 || 400 => AppFailureType.validation,
    429 => AppFailureType.rateLimit,
    >= 500 => AppFailureType.server,
    _ => AppFailureType.unknown,
  };
}

String _defaultMessageFor(AppFailureType type) {
  return switch (type) {
    AppFailureType.unauthorized => 'Please sign in to continue.',
    AppFailureType.forbidden => 'You do not have permission to do that.',
    AppFailureType.notFound => 'The requested item was not found.',
    AppFailureType.validation => 'Check the details and try again.',
    AppFailureType.rateLimit => 'Too many requests. Try again later.',
    AppFailureType.server => 'Something went wrong on our side.',
    _ => 'Something went wrong. Try again.',
  };
}

String? _messageFromBody(Object? body) {
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

AuthTokens? _extractRefreshedTokens(Object? body) {
  var map = _mapFrom(body);
  if (map == null) {
    return null;
  }
  map = _mapFrom(map['data']) ?? map;
  map = _mapFrom(map['session']) ?? map;

  final accessToken = map['access_token'];
  if (accessToken is! String || accessToken.isEmpty) {
    return null;
  }

  final expiresAt = map['expires_at'];
  return AuthTokens(
    accessToken: accessToken,
    refreshToken: map['refresh_token'] is String
        ? map['refresh_token'] as String
        : null,
    tokenType: map['token_type'] is String ? map['token_type'] as String : null,
    expiresIn: map['expires_in'] is num ? (map['expires_in']! as num).toInt() : null,
    expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
  );
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}
