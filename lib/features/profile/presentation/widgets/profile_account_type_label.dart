import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/promoo_profile.dart';

/// Resolves the localized label for a [ProfileAccountType]. Split from the
/// domain entity because it needs `AppLocalizations`, which domain code
/// doesn't have access to. Reuses the Auth feature's account-type strings
/// (same English words) and Leaderboard's "unknown" fallback.
String profileAccountTypeLabel(BuildContext context, ProfileAccountType type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    ProfileAccountType.company => l10n.authAccountTypeCompany,
    ProfileAccountType.influencer => l10n.authAccountTypeInfluencer,
    ProfileAccountType.serviceProvider => l10n.authAccountTypeServiceProvider,
    ProfileAccountType.user => l10n.profileAccountTypeUser,
    ProfileAccountType.unknown => l10n.leaderboardAccountTypeFallback,
  };
}
