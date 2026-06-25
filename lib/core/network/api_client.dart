import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'api_exception.dart';
import 'api_response.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);

  return Dio(
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
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.patch<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
      decode: decode,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    T Function(Object? data)? decode,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.delete<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
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
        throw ApiException(
          type: ApiExceptionType.unknown,
          message: parsed.message ?? 'The request failed.',
          statusCode: response.statusCode,
          code: parsed.error?.code,
          details: parsed.error?.details,
        );
      }

      return parsed;
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    } on FormatException catch (error) {
      throw ApiException.parsing(error.message);
    }
  }
}
