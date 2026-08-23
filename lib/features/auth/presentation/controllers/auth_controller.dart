import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/cache_clear.dart';
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

/// Client-side validation failures for the Login/Register forms. Kept as an
/// enum (not a string) so the presentation layer can resolve the message via
/// `AppLocalizations` — this controller has no `BuildContext`.
enum AuthValidationIssue {
  emailRequired,
  emailInvalid,
  passwordRequired,
  fullNameTooShort,
  passwordTooShort,
}

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.failure,
    this.validationIssue,
    this.registrationPending = false,
    this.sessionExpired = false,
  });

  const AuthState.unauthenticated({bool registrationPending = false})
    : this(
        status: AuthStatus.unauthenticated,
        registrationPending: registrationPending,
      );

  /// The token expired and refreshing failed (see the network refresh
  /// interceptor). Signed-out, but flagged so Login can explain why the user
  /// landed there instead of showing a blank form.
  const AuthState.sessionExpired()
    : this(status: AuthStatus.unauthenticated, sessionExpired: true);

  const AuthState.authenticating() : this(status: AuthStatus.authenticating);

  const AuthState.authenticated(AuthSession session)
    : this(status: AuthStatus.authenticated, session: session);

  const AuthState.validationError(AuthValidationIssue issue)
    : this(status: AuthStatus.validationError, validationIssue: issue);

  const AuthState.error(AppFailure failure)
    : this(status: AuthStatus.error, failure: failure);

  const AuthState.loggingOut(AuthSession? session)
    : this(status: AuthStatus.loggingOut, session: session);

  final AuthStatus status;
  final AuthSession? session;
  final AppFailure? failure;
  final AuthValidationIssue? validationIssue;

  /// True right after registration, before the demo/verification message is
  /// shown — resolved to text by the presentation layer.
  final bool registrationPending;

  /// True when the user was bounced to Login by an expired session (not a
  /// deliberate logout). Resolved to a notice by the presentation layer.
  final bool sessionExpired;

  bool get isAuthenticated => session?.isAuthenticated ?? false;

  bool get isBusy {
    return status == AuthStatus.authenticating ||
        status == AuthStatus.loggingOut;
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
    if (state.isAuthenticated) {
      _scheduleClearUserSessionCaches();
    }
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
    if (state.isAuthenticated) {
      _scheduleClearUserSessionCaches();
    }
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
    _scheduleClearUserSessionCaches();
  }

  /// Called (via the app-root listener on `sessionExpiredSignalProvider`) when
  /// the network layer gave up refreshing an expired token. Drops the stale
  /// in-memory session so the whole app re-renders as signed-out; the store
  /// was already cleared by the interceptor.
  void onSessionExpired() {
    if (_disposed) {
      return;
    }
    state = const AuthState.sessionExpired();
    _scheduleClearUserSessionCaches();
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

    return const AuthState.unauthenticated(registrationPending: true);
  }

  /// Providers like [chatRealtimeServiceProvider] listen to this controller.
  /// Invalidating them *while* auth state is still being written creates a
  /// Riverpod circular dependency — schedule the wipe for the next microtask
  /// so the auth update finishes first.
  void _scheduleClearUserSessionCaches() {
    Future.microtask(() {
      if (_disposed) {
        return;
      }
      clearUserSessionCaches(ref);
    });
  }

  AuthValidationIssue? _validateEmailPassword({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      return AuthValidationIssue.emailRequired;
    }
    if (!_emailPattern.hasMatch(normalizedEmail)) {
      return AuthValidationIssue.emailInvalid;
    }
    if (password.isEmpty) {
      return AuthValidationIssue.passwordRequired;
    }
    return null;
  }

  AuthValidationIssue? _validateRegister({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.trim().length < 2) {
      return AuthValidationIssue.fullNameTooShort;
    }

    final baseValidation = _validateEmailPassword(
      email: email,
      password: password,
    );
    if (baseValidation != null) {
      return baseValidation;
    }

    if (password.length < 8) {
      return AuthValidationIssue.passwordTooShort;
    }

    return null;
  }
}
