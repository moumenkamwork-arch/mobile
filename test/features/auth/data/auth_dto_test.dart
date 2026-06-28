import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/auth/data/dto/auth_dto.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';

void main() {
  test('parses login response with user and session tokens', () {
    final dto = AuthSessionDto.fromJsonFlexible({
      'success': true,
      'data': {
        'user': {
          'id': 'user-1',
          'email': 'alya@promoo.app',
          'user_metadata': {
            'full_name': 'Alya Hassan',
            'account_type': 'company',
          },
          'email_confirmed_at': '2026-06-26T00:00:00.000Z',
        },
        'session': {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
          'token_type': 'bearer',
          'expires_in': 3600,
        },
      },
    });

    final session = dto.toDomain();

    expect(session.isAuthenticated, isTrue);
    expect(session.user.email, 'alya@promoo.app');
    expect(session.user.fullName, 'Alya Hassan');
    expect(session.user.accountType, AuthAccountType.company);
    expect(session.tokens?.accessToken, 'access-1');
  });

  test('parses registration response that requires verification', () {
    final dto = AuthSessionDto.fromJsonFlexible({
      'user': {
        'id': 'user-1',
        'email': 'pending@promoo.app',
        'user_metadata': {'full_name': 'Pending User'},
      },
      'session': null,
    });

    final session = dto.toDomain();

    expect(session.isAuthenticated, isFalse);
    expect(session.requiresVerification, isTrue);
    expect(session.user.displayName, 'Pending User');
  });

  test('parses token refresh response with nested session user', () {
    final dto = AuthSessionDto.fromJsonFlexible({
      'session': {
        'access_token': 'new-access',
        'refresh_token': 'new-refresh',
        'user': {
          'id': 'user-1',
          'email': 'alya@promoo.app',
          'user_metadata': {'account_type': 'service_provider'},
        },
      },
    });

    final session = dto.toDomain();

    expect(session.tokens?.accessToken, 'new-access');
    expect(session.user.accountType, AuthAccountType.serviceProvider);
  });
}
