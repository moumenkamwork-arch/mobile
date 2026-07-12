import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';
import 'leaderboard_labels.dart';

class LeaderboardProfileCard extends StatelessWidget {
  const LeaderboardProfileCard({
    super.key,
    required this.profile,
    this.highlight = false,
    this.onTap,
  });

  final LeaderboardProfile profile;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final rankIsPodium = profile.rank.isPodium;
    final colors = context.colors;

    return PromooCard(
      elevated: highlight,
      borderColor: highlight ? colors.accent : colors.border,
      color: highlight ? colors.elevatedSurface : colors.cardSurface,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RankBadge(rank: profile.rank, highlight: rankIsPodium),
          const SizedBox(width: AppSpacing.md),
          _ProfileAvatar(profile: profile, radius: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (profile.isVerified) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        Icons.verified_rounded,
                        size: 18,
                        color: colors.accent,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _metadataFor(context, profile).join(' / '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right_rounded,
            color: highlight ? colors.accent : colors.textMuted,
          ),
        ],
      ),
    );
  }
}

List<String> _metadataFor(BuildContext context, LeaderboardProfile profile) {
  return [
    if (profile.username != null) '@${profile.username}',
    leaderboardAccountTypeLabel(context, profile.accountType),
    leaderboardFollowersLabel(context, profile),
    if (profile.badgeLabel != null) profile.badgeLabel!,
  ];
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.highlight});

  final LeaderboardRank rank;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Podium ranks get the highlighter treatment: yellow fill + black ink.
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight ? colors.primaryYellow : colors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: highlight ? colors.primaryYellow : colors.border,
        ),
      ),
      child: Text(
        rank.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: highlight ? AppColors.brandBlack : colors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profile, required this.radius});

  final LeaderboardProfile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    final colors = context.colors;

    final diameter = radius * 2;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: profile.rank.isPodium ? colors.accent : colors.borderStrong,
        ),
      ),
      child: ClipOval(
        child: avatarUrl == null
            ? Center(
                child: Text(
                  _initialsFor(profile.displayName),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : PromooImage(
                imageUrl: avatarUrl,
                fallbackIcon: Icons.person_rounded,
                semanticLabel: profile.displayName,
              ),
      ),
    );
  }
}

String _initialsFor(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return 'P';
  }
  if (parts.length == 1) {
    return _firstCharacter(parts.first).toUpperCase();
  }
  return '${_firstCharacter(parts.first)}${_firstCharacter(parts.last)}'
      .toUpperCase();
}

String _firstCharacter(String value) {
  return String.fromCharCode(value.runes.first);
}
