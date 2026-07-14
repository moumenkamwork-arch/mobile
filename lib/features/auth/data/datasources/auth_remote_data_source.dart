import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/auth_session.dart';
import '../dto/auth_dto.dart';
import 'auth_data_source.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

class AuthRemoteDataSource implements AuthDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSessionDto> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<AuthSessionDto>(
      ApiEndpoints.loginEmail,
      data: {'email': email, 'password': password},
      decode: AuthSessionDto.fromJsonFlexible,
    );

    return response.data ?? const AuthSessionDto();
  }

  @override
  Future<AuthSessionDto> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    final response = await _apiClient.post<AuthSessionDto>(
      ApiEndpoints.registerEmail,
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'account_type': accountType.apiValue,
      },
      decode: AuthSessionDto.fromJsonFlexible,
    );

    return response.data ?? const AuthSessionDto();
  }

  @override
  Future<AuthSessionDto> refreshSession({required String refreshToken}) async {
    final response = await _apiClient.post<AuthSessionDto>(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      decode: AuthSessionDto.fromJsonFlexible,
    );

    return response.data ?? const AuthSessionDto();
  }

  @override
  Future<void> logout({String? accessToken}) async {
    await _apiClient.post<void>(
      ApiEndpoints.logout,
      headers: accessToken == null
          ? null
          : {'Authorization': 'Bearer $accessToken'},
      decode: (_) {},
    );
  }
}
