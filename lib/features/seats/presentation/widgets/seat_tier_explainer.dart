import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';

class SeatTierExplainer extends StatelessWidget {
  const SeatTierExplainer({super.key});

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Placement tiers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Choose the visibility level that fits the campaign.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          const _TierRow(
            tier: SeatTier.gold,
            title: 'Gold visibility',
            message: 'Highest placement for maximum profile exposure.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _TierRow(
            tier: SeatTier.silver,
            title: 'Silver placement',
            message: 'Strong discovery position for active campaigns.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _TierRow(
            tier: SeatTier.bronze,
            title: 'Bronze visibility',
            message: 'Starter placement for consistent marketplace presence.',
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.tier,
    required this.title,
    required this.message,
  });

  final SeatTier tier;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(tier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Icon(_tierIcon(tier), color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xxxs),
              Text(message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

Color _tierColor(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => AppColors.primaryYellow,
    SeatTier.silver => AppColors.textSecondary,
    SeatTier.bronze => AppColors.darkYellow,
    SeatTier.unknown => AppColors.borderStrong,
  };
}

IconData _tierIcon(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => Icons.workspace_premium_rounded,
    SeatTier.silver => Icons.star_half_rounded,
    SeatTier.bronze => Icons.shield_rounded,
    SeatTier.unknown => Icons.event_seat_rounded,
  };
}
