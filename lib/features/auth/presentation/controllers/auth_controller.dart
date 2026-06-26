import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  error,
  validationError,
  loggingOut,
}

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.failure,
    this.validationMessage,
    this.successMessage,
  });

  const AuthState.unauthenticated({String? successMessage})
    : this(status: AuthStatus.unauthenticated, successMessage: successMessage);

  const AuthState.authenticating() : this(status: AuthStatus.authenticating);

  const AuthState.authenticated(AuthSession session)
    : this(status: AuthStatus.authenticated, session: session);

  const AuthState.validationError(String message)
    : this(status: AuthStatus.validationError, validationMessage: message);

  const AuthState.error(AppFailure failure)
    : this(status: AuthStatus.error, failure: failure);

  const AuthState.loggingOut(AuthSession? session)
    : this(status: AuthStatus.loggingOut, session: session);

  final AuthStatus status;
  final AuthSession? session;
  final AppFailure? failure;
  final String? validationMessage;
  final String? successMessage;

  bool get isAuthenticated => session?.isAuthenticated ?? false;

  bool get isBusy {
    return status == AuthStatus.authenticating ||
        status == AuthStatus.loggingOut;
  }

  String? get displayMessage {
    return validationMessage ?? failure?.message ?? successMessage;
  }
}

class AuthController extends Notifier<AuthState> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  var _disposed = false;

  @override
  AuthState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_restoreSession));
    return const AuthState.unauthenticated();
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final validation = _validateEmailPassword(email: email, password: password);
    if (validation != null) {
      state = AuthState.validationError(validation);
      return;
    }

    state = const AuthState.authenticating();
    final result = await ref
        .read(authRepositoryProvider)
        .loginWithEmail(email: email.trim(), password: password);
    if (_disposed) {
      return;
    }

    state = result.when(success: _stateForSession, failure: AuthState.error);
  }

  Future<void> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    final validation = _validateRegister(
      fullName: fullName,
      email: email,
      password: password,
    );
    if (validation != null) {
      state = AuthState.validationError(validation);
      return;
    }

    state = const AuthState.authenticating();
    final result = await ref
        .read(authRepositoryProvider)
        .registerWithEmail(
          fullName: fullName.trim(),
          email: email.trim(),
          password: password,
          accountType: accountType,
        );
    if (_disposed) {
      return;
    }

    state = result.when(success: _stateForSession, failure: AuthState.error);
  }

  Future<void> logout() async {
    final previousSession = state.session;
    state = AuthState.loggingOut(previousSession);
    final result = await ref.read(authRepositoryProvider).logout();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (_) => const AuthState.unauthenticated(),
      failure: AuthState.error,
    );
  }

  void clearMessage() {
    if (state.isAuthenticated && state.session != null) {
      state = AuthState.authenticated(state.session!);
      return;
    }
    state = const AuthState.unauthenticated();
  }

  Future<void> _restoreSession() async {
    final result = await ref.read(authRepositoryProvider).getStoredSession();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (session) {
        if (session == null || !session.isAuthenticated) {
          return state;
        }
        return AuthState.authenticated(session);
      },
      failure: (_) => state,
    );
  }

  AuthState _stateForSession(AuthSession session) {
    if (session.isAuthenticated) {
      return AuthState.authenticated(session);
    }

    return const AuthState.unauthenticated(
      successMessage:
          'Registration created. Please verify your account before signing in.',
    );
  }

  String? _validateEmailPassword({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      return 'Email is required.';
    }
    if (!_emailPattern.hasMatch(normalizedEmail)) {
      return 'Enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  String? _validateRegister({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.trim().length < 2) {
      return 'Full name must be at least 2 characters.';
    }

    final baseValidation = _validateEmailPassword(
      email: email,
      password: password,
    );
    if (baseValidation != null) {
      return baseValidation;
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }
}
