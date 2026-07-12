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

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromooSectionHeader(
          title: l10n.leaderboardRankingTitle,
          subtitle: l10n.leaderboardRankingSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < sortedProfiles.length; i++) ...[
          LeaderboardProfileCard(
            profile: sortedProfiles[i],
            highlight: sortedProfiles[i].rank.isPodium,
            onTap: onProfileSelected == null
                ? null
                : () => onProfileSelected!(sortedProfiles[i]),
          ),
          if (i != sortedProfiles.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
