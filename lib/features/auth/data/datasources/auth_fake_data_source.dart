import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../dto/auth_dto.dart';
import 'auth_data_source.dart';

final authFakeDataSourceProvider = Provider<AuthFakeDataSource>((ref) {
  return const AuthFakeDataSource();
});

class AuthFakeDataSource implements AuthDataSource {
  const AuthFakeDataSource();

  @override
  Future<AuthSessionDto> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _throwIfInvalid(password);

    return _sessionFor(email: email, fullName: 'Promoo Demo User');
  }

  @override
  Future<AuthSessionDto> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    _throwIfInvalid(password);

    return _sessionFor(
      email: email,
      fullName: fullName,
      accountType: accountType,
    );
  }

  @override
  Future<AuthSessionDto> refreshSession({required String refreshToken}) async {
    if (refreshToken.trim().isEmpty) {
      throw const ApiException(
        type: ApiExceptionType.unauthorized,
        message: 'Refresh token is missing.',
      );
    }

    return _sessionFor(email: 'demo@promoo.app', fullName: 'Promoo Demo User');
  }

  @override
  Future<void> logout({String? accessToken}) async {}

  void _throwIfInvalid(String password) {
    if (password == 'fail') {
      throw const ApiException(
        type: ApiExceptionType.unauthorized,
        message: 'Invalid email or password.',
      );
    }
  }

  AuthSessionDto _sessionFor({
    required String email,
    required String fullName,
    AuthAccountType accountType = AuthAccountType.user,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    return AuthSessionDto.fromJsonFlexible({
      'user': {
        'id': 'auth-demo-user',
        'email': normalizedEmail,
        'user_metadata': {
          'full_name': fullName,
          'account_type': accountType.apiValue,
        },
        'email_confirmed_at': '2026-06-26T00:00:00.000Z',
      },
      'session': {
        'access_token': 'fake-access-token',
        'refresh_token': 'fake-refresh-token',
        'token_type': 'bearer',
        'expires_in': 3600,
      },
    });
  }
}
