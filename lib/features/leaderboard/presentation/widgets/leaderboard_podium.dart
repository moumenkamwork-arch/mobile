import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({super.key, required this.profiles});

  final List<LeaderboardProfile> profiles;

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
      borderColor: AppColors.primaryYellow,
      color: AppColors.elevatedSurface,
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
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
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
          _ChampionTile(profile: champion),
          if (runnersUp.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                for (var i = 0; i < runnersUp.length; i++) ...[
                  Expanded(child: _RunnerUpTile(profile: runnersUp[i])),
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
  const _ChampionTile({required this.profile});

  final LeaderboardProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0x24FFE604),
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.primaryYellow),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.brandBlack,
            backgroundImage: profile.avatarUrl == null
                ? null
                : NetworkImage(profile.avatarUrl!),
            child: profile.avatarUrl == null
                ? Text(
                    _initialsFor(profile.displayName),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryYellow,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : null,
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
            profile.followersLabel,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.primaryYellow),
          ),
        ],
      ),
    );
  }
}

class _RunnerUpTile extends StatelessWidget {
  const _RunnerUpTile({required this.profile});

  final LeaderboardProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            profile.rank.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryYellow,
              fontWeight: FontWeight.w800,
            ),
          ),
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
