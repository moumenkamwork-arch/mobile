import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_profile.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooCard(
      child: Row(
        children: [
          _StatItem(label: l10n.profileStatsFollowers, value: stats.followers),
          _Divider(),
          _StatItem(label: l10n.profileStatsLikes, value: stats.likes),
          _Divider(),
          _StatItem(label: l10n.profileStatsPosts, value: stats.posts),
          _Divider(),
          _StatItem(label: l10n.profileStatsViews, value: stats.views),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _compact(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: context.colors.accent),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: context.colors.border);
  }
}

String _compact(int value) {
  if (value >= 1000000) {
    final millions = value / 1000000;
    return '${_format(millions)}M';
  }
  if (value >= 1000) {
    final thousands = value / 1000;
    return '${_format(thousands)}K';
  }
  return '$value';
}

String _format(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
