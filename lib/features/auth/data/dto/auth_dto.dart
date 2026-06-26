import '../../domain/entities/auth_session.dart';

class AuthSessionDto {
  const AuthSessionDto({
    this.user,
    this.tokens,
    this.requiresVerification = false,
  });

  final AuthUserDto? user;
  final AuthTokensDto? tokens;
  final bool requiresVerification;

  factory AuthSessionDto.fromJsonFlexible(Object? value) {
    final map = _mapFrom(value);
    if (map == null) {
      return const AuthSessionDto();
    }

    final data = _mapFrom(map['data']);
    if (data != null && _looksLikeEnvelope(map)) {
      return AuthSessionDto.fromJsonFlexible(data);
    }

    final rawSession = _mapFrom(map['session']);
    final rawUser =
        _mapFrom(map['user']) ??
        (rawSession == null ? null : _mapFrom(rawSession['user'])) ??
        _mapFrom(map['profile']) ??
        _mapFrom(map['account']);

    final tokens = rawSession == null
        ? AuthTokensDto.fromJsonFlexible(map)
        : AuthTokensDto.fromJsonFlexible(rawSession);
    final hasTokens = tokens.accessToken != null;

    return AuthSessionDto(
      user: rawUser == null ? null : AuthUserDto.fromJson(rawUser),
      tokens: hasTokens ? tokens : null,
      requiresVerification: rawSession == null && rawUser != null,
    );
  }

  AuthSession toDomain() {
    final mappedUser = user?.toDomain();
    if (mappedUser == null) {
      throw const FormatException('Expected auth user in response.');
    }

    return AuthSession(
      user: mappedUser,
      tokens: tokens?.toDomain(),
      requiresVerification: requiresVerification,
    );
  }
}

class AuthUserDto {
  const AuthUserDto({
    this.id,
    this.email,
    this.phone,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.accountType,
    this.isVerified = false,
  });

  final String? id;
  final String? email;
  final String? phone;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String? accountType;
  final bool isVerified;

  factory AuthUserDto.fromJson(Map<String, Object?> json) {
    final metadata =
        _mapFrom(json['user_metadata']) ??
        _mapFrom(json['raw_user_meta_data']) ??
        _mapFrom(json['metadata']);

    return AuthUserDto(
      id: _readString(json, const ['id', 'user_id', 'profile_id']),
      email: _readString(json, const ['email']),
      phone: _readString(json, const ['phone']),
      fullName:
          _readString(json, const ['full_name', 'fullName', 'display_name']) ??
          _readString(metadata, const [
            'full_name',
            'fullName',
            'display_name',
          ]),
      username: _readString(json, const ['username']),
      avatarUrl: _readString(json, const ['avatar_url', 'avatarUrl']),
      accountType:
          _readString(json, const ['account_type', 'accountType']) ??
          _readString(metadata, const ['account_type', 'accountType']),
      isVerified:
          _readBool(json, const ['is_verified', 'isVerified']) ||
          _readString(json, const ['email_confirmed_at', 'confirmed_at']) !=
              null,
    );
  }

  AuthUser? toDomain() {
    if (id == null) {
      return null;
    }

    return AuthUser(
      id: id!,
      email: email,
      phone: phone,
      fullName: fullName,
      username: username,
      avatarUrl: avatarUrl,
      accountType: AuthAccountTypeValue.fromValue(accountType),
      isVerified: isVerified,
    );
  }
}

class AuthTokensDto {
  const AuthTokensDto({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.expiresAt,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final DateTime? expiresAt;

  factory AuthTokensDto.fromJsonFlexible(Object? value) {
    final map = _mapFrom(value);
    if (map == null) {
      return const AuthTokensDto();
    }

    final session = _mapFrom(map['session']);
    if (session != null) {
      return AuthTokensDto.fromJsonFlexible(session);
    }

    return AuthTokensDto(
      accessToken: _readString(map, const [
        'access_token',
        'accessToken',
        'token',
      ]),
      refreshToken: _readString(map, const ['refresh_token', 'refreshToken']),
      tokenType: _readString(map, const ['token_type', 'tokenType']),
      expiresIn: _readInt(map, const ['expires_in', 'expiresIn']),
      expiresAt: _readDateTime(map, const ['expires_at', 'expiresAt']),
    );
  }

  AuthTokens? toDomain() {
    if (accessToken == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken!,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      expiresAt: expiresAt,
    );
  }
}

bool _looksLikeEnvelope(Map<String, Object?> map) {
  return map.containsKey('success') ||
      map.containsKey('message') ||
      map.containsKey('error');
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

num? _readNum(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return null;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
  }
  return null;
}

int? _readInt(Map<String, Object?>? map, List<String> keys) {
  return _readNum(map, keys)?.toInt();
}

bool _readBool(Map<String, Object?>? map, List<String> keys) {
  if (map == null) {
    return false;
  }
  for (final key in keys) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }
  }
  return false;
}

DateTime? _readDateTime(Map<String, Object?>? map, List<String> keys) {
  final value = _readString(map, keys);
  if (value == null) {
    return null;
  }

  final seconds = int.tryParse(value);
  if (seconds != null) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  return DateTime.tryParse(value);
}
