import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/leaderboard_profile.dart';

/// Resolves the localized "N followers" line for a [LeaderboardProfile].
/// Split from the domain entity because the grammar (plural forms below
/// 1000, a fixed word after a K/M-compact count) needs `AppLocalizations`,
/// which domain code doesn't have access to.
String leaderboardFollowersLabel(
  BuildContext context,
  LeaderboardProfile profile,
) {
  final l10n = AppLocalizations.of(context);
  final compact = profile.compactFollowersCount;
  if (compact != null) {
    return l10n.leaderboardFollowersCompact(compact);
  }
  return l10n.leaderboardFollowersCount(profile.followersCount);
}

/// Resolves the localized account-type label for a [LeaderboardProfile].
/// Reuses the Auth feature's account-type strings (same English words) rather
/// than duplicating them under a new key.
String leaderboardAccountTypeLabel(BuildContext context, String? accountType) {
  final l10n = AppLocalizations.of(context);
  return switch (accountType) {
    'company' => l10n.authAccountTypeCompany,
    'influencer' => l10n.authAccountTypeInfluencer,
    'service_provider' => l10n.authAccountTypeServiceProvider,
    _ => l10n.leaderboardAccountTypeFallback,
  };
}
