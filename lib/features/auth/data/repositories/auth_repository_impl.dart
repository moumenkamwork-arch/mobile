import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../datasources/auth_fake_data_source.dart';
import '../dto/auth_dto.dart';
import '../session/auth_session_store.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dataSource: ref.watch(authFakeDataSourceProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.dataSource,
    required this.sessionStore,
  });

  final AuthDataSource dataSource;
  final AuthSessionStore sessionStore;

  @override
  Future<Result<AuthSession?>> getStoredSession() async {
    try {
      return Result.success(await sessionStore.read());
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<AuthSession>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      () => dataSource.loginWithEmail(email: email, password: password),
    );
  }

  @override
  Future<Result<AuthSession>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    return _authenticate(
      () => dataSource.registerWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        accountType: accountType,
      ),
    );
  }

  @override
  Future<Result<AuthSession>> refreshSession() async {
    try {
      final currentSession = await sessionStore.read();
      final refreshToken = currentSession?.tokens?.refreshToken;
      if (refreshToken == null || refreshToken.trim().isEmpty) {
        return const Result.failure(
          AppFailure.unauthorized(message: 'Please sign in again.'),
        );
      }

      final dto = await dataSource.refreshSession(refreshToken: refreshToken);
      final session = dto.toDomain();
      await _persistIfAuthenticated(session);
      return Result.success(session);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final currentSession = await sessionStore.read();
      await dataSource.logout(accessToken: currentSession?.tokens?.accessToken);
      await sessionStore.clear();
      return const Result.success(null);
    } on AppFailure catch (failure) {
      await sessionStore.clear();
      return Result.failure(failure);
    } catch (_) {
      await sessionStore.clear();
      return const Result.failure(AppFailure.unknown());
    }
  }

  Future<Result<AuthSession>> _authenticate(
    Future<AuthSessionDto> Function() request,
  ) async {
    try {
      final dto = await request();
      final session = dto.toDomain();
      await _persistIfAuthenticated(session);
      return Result.success(session);
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  Future<void> _persistIfAuthenticated(AuthSession session) async {
    if (session.isAuthenticated) {
      await sessionStore.write(session);
    } else {
      await sessionStore.clear();
    }
  }
}
