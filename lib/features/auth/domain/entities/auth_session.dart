enum AuthAccountType { user, company, influencer, serviceProvider }

extension AuthAccountTypeValue on AuthAccountType {
  static AuthAccountType fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'company' => AuthAccountType.company,
      'influencer' => AuthAccountType.influencer,
      'service_provider' ||
      'serviceprovider' => AuthAccountType.serviceProvider,
      _ => AuthAccountType.user,
    };
  }

  String get apiValue {
    return switch (this) {
      AuthAccountType.user => 'user',
      AuthAccountType.company => 'company',
      AuthAccountType.influencer => 'influencer',
      AuthAccountType.serviceProvider => 'service_provider',
    };
  }

  String get label {
    return switch (this) {
      AuthAccountType.user => 'User',
      AuthAccountType.company => 'Company',
      AuthAccountType.influencer => 'Influencer',
      AuthAccountType.serviceProvider => 'Service provider',
    };
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.accountType = AuthAccountType.user,
    this.isVerified = false,
  });

  final String id;
  final String? email;
  final String? phone;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final AuthAccountType accountType;
  final bool isVerified;

  String get displayName {
    return fullName ?? username ?? email ?? phone ?? 'Promoo user';
  }
}

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.expiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final DateTime? expiresAt;

  bool get hasRefreshToken => refreshToken != null && refreshToken!.isNotEmpty;
}

class AuthSession {
  const AuthSession({
    required this.user,
    this.tokens,
    this.requiresVerification = false,
  });

  final AuthUser user;
  final AuthTokens? tokens;
  final bool requiresVerification;

  bool get isAuthenticated => tokens?.accessToken.isNotEmpty ?? false;
}
