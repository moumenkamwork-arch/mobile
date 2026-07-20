import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';
import 'leaderboard_profile_card.dart';

class LeaderboardRankedList extends StatelessWidget {
  const LeaderboardRankedList({
    super.key,
    required this.profiles,
    this.onProfileSelected,
  });

  final List<LeaderboardProfile> profiles;
  final ValueChanged<LeaderboardProfile>? onProfileSelected;

  @override
  Widget build(BuildContext context) {
    final sortedProfiles = [...profiles]
      ..sort((a, b) => a.rank.value.compareTo(b.rank.value));

    // The medal three sit together as one attached panel; everyone from 4th
    // down is a separate contender row.
    final medalists = sortedProfiles
        .where((p) => p.rank.isPodium)
        .toList(growable: false);
    final contenders = sortedProfiles
        .where((p) => !p.rank.isPodium)
        .toList(growable: false);

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromooSectionHeader(
          title: l10n.leaderboardRankingTitle,
          subtitle: l10n.leaderboardRankingSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (medalists.isNotEmpty)
          LeaderboardMedalGroup(
            profiles: medalists,
            onProfileSelected: onProfileSelected,
          ),
        for (var i = 0; i < contenders.length; i++) ...[
          SizedBox(height: i == 0 ? AppSpacing.sm : AppSpacing.xs),
          LeaderboardProfileCard(
            profile: contenders[i],
            onTap: onProfileSelected == null
                ? null
                : () => onProfileSelected!(contenders[i]),
          ),
        ],
      ],
    );
  }
}
