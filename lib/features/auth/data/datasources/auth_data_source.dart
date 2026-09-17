import '../../domain/entities/auth_session.dart';
import '../dto/auth_dto.dart';

abstract interface class AuthDataSource {
  Future<AuthSessionDto> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSessionDto> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  });

  Future<AuthSessionDto> refreshSession({required String refreshToken});

  Future<void> logout({String? accessToken});
}
