import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_session.dart';

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return const SecureAuthSessionStore();
});

abstract interface class AuthSessionStore {
  Future<AuthSession?> read();

  Future<void> write(AuthSession session);

  Future<void> clear();
}

/// Persists the session on-device via the platform keychain/keystore.
///
/// Mirrors [LocaleController]: storage is best-effort, so on platforms/tests
/// without the plugin, reads simply return null and writes/clears no-op.
class SecureAuthSessionStore implements AuthSessionStore {
  const SecureAuthSessionStore();

  static const _key = 'promoo_auth_session';//! should be in env
  static const _storage = FlutterSecureStorage();

  @override
  Future<AuthSession?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null || raw.isEmpty) {
        return null;
      }
      final json = _mapFrom(jsonDecode(raw));
      return json == null ? null : _sessionFromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(AuthSession session) async {
    try {
      await _storage.write(
        key: _key,
        value: jsonEncode(_sessionToJson(session)),
      );
    } catch (_) {
      // Best effort — nothing more we can do if the secure store is unavailable.
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } catch (_) {
      // Best effort.
    }
  }
}

/// Fast in-memory double for widget tests that don't care about session
/// persistence. [SecureAuthSessionStore]'s real platform channel call never
/// resolves inside `testWidgets` (no device/plugin backing it), so any test
/// that renders a screen touching the access token must override
/// [authSessionStoreProvider] with this instead — see
/// `test/routing/app_routes_smoke_test.dart` for the pattern.
class InMemoryAuthSessionStore implements AuthSessionStore {
  AuthSession? _session;

  @override
  Future<AuthSession?> read() async => _session;

  @override
  Future<void> write(AuthSession session) async {
    _session = session;
  }

  @override
  Future<void> clear() async {
    _session = null;
  }
}

Map<String, Object?> _sessionToJson(AuthSession session) {
  final tokens = session.tokens;
  return {
    'user': {
      'id': session.user.id,
      'email': session.user.email,
      'phone': session.user.phone,
      'full_name': session.user.fullName,
      'username': session.user.username,
      'avatar_url': session.user.avatarUrl,
      'account_type': session.user.accountType.apiValue,
      'is_verified': session.user.isVerified,
    },
    'tokens': tokens == null
        ? null
        : {
            'access_token': tokens.accessToken,
            'refresh_token': tokens.refreshToken,
            'token_type': tokens.tokenType,
            'expires_in': tokens.expiresIn,
            'expires_at': tokens.expiresAt?.toIso8601String(),
          },
    'requires_verification': session.requiresVerification,
  };
}

AuthSession? _sessionFromJson(Map<String, Object?> json) {
  final userJson = _mapFrom(json['user']);
  final id = userJson?['id'];
  if (userJson == null || id is! String || id.isEmpty) {
    return null;
  }

  final tokensJson = _mapFrom(json['tokens']);
  AuthTokens? tokens;
  final accessToken = tokensJson?['access_token'];
  if (tokensJson != null && accessToken is String && accessToken.isNotEmpty) {
    final expiresAt = tokensJson['expires_at'];
    tokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: tokensJson['refresh_token'] as String?,
      tokenType: tokensJson['token_type'] as String?,
      expiresIn: (tokensJson['expires_in'] as num?)?.toInt(),
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
    );
  }

  return AuthSession(
    user: AuthUser(
      id: id,
      email: userJson['email'] as String?,
      phone: userJson['phone'] as String?,
      fullName: userJson['full_name'] as String?,
      username: userJson['username'] as String?,
      avatarUrl: userJson['avatar_url'] as String?,
      accountType: AuthAccountTypeValue.fromValue(
        userJson['account_type'] as String?,
      ),
      isVerified: userJson['is_verified'] == true,
    ),
    tokens: tokens,
    requiresVerification: json['requires_verification'] == true,
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
