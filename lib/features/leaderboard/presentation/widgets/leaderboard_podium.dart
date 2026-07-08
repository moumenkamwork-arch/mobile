import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({
    super.key,
    required this.profiles,
    this.onProfileSelected,
  });

  final List<LeaderboardProfile> profiles;
  final ValueChanged<LeaderboardProfile>? onProfileSelected;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedProfiles = [...profiles]
      ..sort((a, b) => a.rank.value.compareTo(b.rank.value));
    final champion = sortedProfiles.first;
    final runnersUp = sortedProfiles.skip(1).take(2).toList(growable: false);

    return PromooCard(
      elevated: true,
      borderColor: context.colors.accent,
      color: context.colors.elevatedSurface,
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                // Brand highlighter chip: yellow fill + black ink, both modes.
                decoration: const BoxDecoration(
                  color: AppColors.brandYellow,
                  borderRadius: AppRadius.pill,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.brandBlack,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top of the Cup',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Followers-based Promoo standings',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ChampionTile(
            profile: champion,
            onTap: onProfileSelected == null
                ? null
                : () => onProfileSelected!(champion),
          ),
          if (runnersUp.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                for (var i = 0; i < runnersUp.length; i++) ...[
                  Expanded(
                    child: _RunnerUpTile(
                      profile: runnersUp[i],
                      onTap: onProfileSelected == null
                          ? null
                          : () => onProfileSelected!(runnersUp[i]),
                    ),
                  ),
                  if (i != runnersUp.length - 1)
                    const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ChampionTile extends StatelessWidget {
  const _ChampionTile({required this.profile, this.onTap});

  final LeaderboardProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          // Highlighter wash marks the champion in both themes; the border
          // resolves to gold ink on paper for definition.
          decoration: BoxDecoration(
            color: const Color(0x24FFE604),
            borderRadius: AppRadius.card,
            border: Border.all(color: context.colors.accent),
          ),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  _LeaderboardAvatar(profile: profile, radius: 42),
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.brandYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.brandBlack),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.brandBlack,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                profile.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Champion / ${profile.followersLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: context.colors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunnerUpTile extends StatelessWidget {
  const _RunnerUpTile({required this.profile, this.onTap});

  final LeaderboardProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 152),
          child: Ink(
            padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.cardSurface,
              borderRadius: AppRadius.card,
              border: Border.all(color: context.colors.borderStrong),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.rank.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.colors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _LeaderboardAvatar(profile: profile, radius: 25),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  profile.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  profile.followersLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardAvatar extends StatelessWidget {
  const _LeaderboardAvatar({required this.profile, required this.radius});

  final LeaderboardProfile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;

    return Container(
      width: diameter,
      height: diameter,
      // Avatar well stays brand-black in both themes, so the yellow ring and
      // initials keep their contrast.
      decoration: BoxDecoration(
        color: AppColors.brandBlack,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.brandYellow.withValues(alpha: 0.72),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: profile.avatarUrl == null
            ? Center(
                child: Text(
                  _initialsFor(profile.displayName),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.brandYellow,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : PromooImage(
                imageUrl: profile.avatarUrl,
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
