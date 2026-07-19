import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/auth/data/session/auth_session_store.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';

/// Regression for the auth-header bug: on Flutter web `flutter_secure_storage`
/// could silently no-op, so after a successful login the interceptor read back
/// `null` and every authenticated request went out with no `Authorization`
/// header (Chat/Follow/Saved all 401'd while "logged in"). The store now keeps
/// an in-memory mirror of the current session, so `read()` returns the token
/// written this session regardless of whether the on-device store persisted it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const session = AuthSession(
    user: AuthUser(
      id: 'u1',
      email: 'a@b.co',
      fullName: 'QA',
      accountType: AuthAccountType.company,
    ),
    tokens: AuthTokens(accessToken: 'tok-123', refreshToken: 'ref-123'),
  );

  test('read returns the just-written session even when secure storage is unavailable', () async {
    const store = SecureAuthSessionStore();
    await store.clear();

    await store.write(session);
    final read = await store.read();

    // The interceptor reads exactly this to build the Bearer header.
    expect(read?.tokens?.accessToken, 'tok-123');
  });

  test('clear() drops the cached session', () async {
    const store = SecureAuthSessionStore();
    await store.write(session);
    await store.clear();

    expect(await store.read(), isNull);
  });
}
