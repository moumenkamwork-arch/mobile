import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';
import 'leaderboard_labels.dart';
import 'leaderboard_medal.dart';

/// The medal three (ranks 1–3) rendered as one attached panel: their rows sit
/// flush with no gaps, so the metallic leading edges line up into a single
/// continuous gold → silver → bronze rail down the left. This reads as one
/// "podium standings" unit, distinct from the separate contender rows below.
class LeaderboardMedalGroup extends StatelessWidget {
  const LeaderboardMedalGroup({
    super.key,
    required this.profiles,
    this.onProfileSelected,
  });

  final List<LeaderboardProfile> profiles;
  final ValueChanged<LeaderboardProfile>? onProfileSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: AppRadius.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: AppRadius.card,
          border: Border.all(color: colors.borderStrong),
        ),
        child: Column(
          children: [
            for (var i = 0; i < profiles.length; i++) ...[
              if (i != 0)
                // Inset past the colour rail so it stays continuous.
                Divider(height: 1, thickness: 1, indent: 4, color: colors.border),
              _LeaderboardRow(
                profile: profiles[i],
                onTap: onProfileSelected == null
                    ? null
                    : () => onProfileSelected!(profiles[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A standalone contender row (rank 4 and below): the same row content, but
/// wrapped in its own bordered tile so it reads as a separate line rather than
/// part of the medal group.
class LeaderboardProfileCard extends StatelessWidget {
  const LeaderboardProfileCard({super.key, required this.profile, this.onTap});

  final LeaderboardProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: AppRadius.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: colors.border),
        ),
        child: _LeaderboardRow(profile: profile, onTap: onTap),
      ),
    );
  }
}

/// Bare row content — a fixed rank lane, the metallic leading edge, the
/// profile's identity, and its follower reach. Carries no outer decoration so
/// it can sit inside either the grouped panel or a standalone tile.
class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.profile, this.onTap});

  final LeaderboardProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final medal = medalForRank(profile.rank.value);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Metallic leading edge — transparent off-podium so every row
              // keeps the same text inset.
              Container(width: 4, color: medal?.sheen ?? Colors.transparent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${profile.rank.value}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: medal?.sheen ?? colors.textMuted,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _ProfileAvatar(profile: profile, radius: 22, medal: medal),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _Identity(profile: profile)),
                      const SizedBox(width: AppSpacing.sm),
                      _Reach(profile: profile),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.profile});

  final LeaderboardProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleParts = [
      if (profile.username != null) '@${profile.username}',
      leaderboardAccountTypeLabel(context, profile.accountType),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                profile.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (profile.isVerified) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.verified_rounded, size: 16, color: colors.accent),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxxs),
        Text(
          subtitleParts.join('  ·  '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// The right-aligned follower count — the reach the standings rank by.
class _Reach extends StatelessWidget {
  const _Reach({required this.profile});

  final LeaderboardProfile profile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: Text(
        leaderboardFollowersLabel(context, profile),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.profile,
    required this.radius,
    this.medal,
  });

  final LeaderboardProfile profile;
  final double radius;
  final MedalTier? medal;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    final colors = context.colors;
    final diameter = radius * 2;

    final inner = Container(
      decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
      child: ClipOval(
        child: avatarUrl == null
            ? Center(
                child: Text(
                  _initialsFor(profile.displayName),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: medal?.sheen ?? colors.accent,
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

    if (medal == null) {
      return SizedBox(width: diameter, height: diameter, child: inner);
    }

    // Podium rows wear the same metal ring the ceremony above uses.
    return Container(
      width: diameter,
      height: diameter,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [medal!.sheen, medal!.shade],
        ),
      ),
      child: inner,
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
