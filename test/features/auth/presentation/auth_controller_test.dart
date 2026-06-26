import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:promoo_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  test('starts unauthenticated', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const _AuthRepository(storedSessionResult: Result.success(null)),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(authControllerProvider).status,
      AuthStatus.unauthenticated,
    );
  });

  test('sets validation error for invalid login form', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const _AuthRepository(storedSessionResult: Result.success(null)),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(authControllerProvider.notifier)
        .loginWithEmail(email: 'invalid', password: '');

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.validationError);
    expect(state.validationMessage, 'Enter a valid email address.');
  });

  test('emits authenticating then authenticated', () async {
    final completer = Completer<Result<AuthSession>>();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _AuthRepository(
            storedSessionResult: const Result.success(null),
            loginCompleter: completer,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final future = container
        .read(authControllerProvider.notifier)
        .loginWithEmail(email: 'demo@promoo.app', password: 'password123');

    expect(
      container.read(authControllerProvider).status,
      AuthStatus.authenticating,
    );

    completer.complete(const Result.success(_session));
    await future;

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.session?.user.email, 'demo@promoo.app');
  });

  test('emits error when login fails', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const _AuthRepository(
            storedSessionResult: Result.success(null),
            loginResult: Result.failure(
              AppFailure.unauthorized(message: 'Invalid credentials'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(authControllerProvider.notifier)
        .loginWithEmail(email: 'demo@promoo.app', password: 'password123');

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.error);
    expect(state.failure?.message, 'Invalid credentials');
  });

  test('logs out to unauthenticated state', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const _AuthRepository(
            storedSessionResult: Result.success(_session),
            logoutResult: Result.success(null),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.authenticated,
    );

    await container.read(authControllerProvider.notifier).logout();

    expect(
      container.read(authControllerProvider).status,
      AuthStatus.unauthenticated,
    );
  });
}

const _session = AuthSession(
  user: AuthUser(id: 'user-1', email: 'demo@promoo.app', fullName: 'Demo User'),
  tokens: AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
);

class _AuthRepository implements AuthRepository {
  const _AuthRepository({
    required this.storedSessionResult,
    this.loginResult = const Result.success(_session),
    this.logoutResult = const Result.success(null),
    this.loginCompleter,
  });

  final Result<AuthSession?> storedSessionResult;
  final Result<AuthSession> loginResult;
  final Result<void> logoutResult;
  final Completer<Result<AuthSession>>? loginCompleter;

  @override
  Future<Result<AuthSession?>> getStoredSession() async {
    return storedSessionResult;
  }

  @override
  Future<Result<AuthSession>> loginWithEmail({
    required String email,
    required String password,
  }) {
    return loginCompleter?.future ?? Future.value(loginResult);
  }

  @override
  Future<Result<AuthSession>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    return loginResult;
  }

  @override
  Future<Result<AuthSession>> refreshSession() async {
    return loginResult;
  }

  @override
  Future<Result<void>> logout() async {
    return logoutResult;
  }
}
