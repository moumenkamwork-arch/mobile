import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession?>> getStoredSession();

  Future<Result<AuthSession>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Result<AuthSession>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  });

  Future<Result<AuthSession>> refreshSession();

  Future<Result<void>> logout();
}
