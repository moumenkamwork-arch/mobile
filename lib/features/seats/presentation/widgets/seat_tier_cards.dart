import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';

class SeatTierCards extends StatelessWidget {
  const SeatTierCards({
    super.key,
    required this.selectedTier,
    required this.onSelected,
  });

  final SeatTier? selectedTier;
  final ValueChanged<SeatTier?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _displayTiers.length; i++) ...[
          Expanded(
            child: _SeatTierCard(
              tier: _displayTiers[i],
              selected: selectedTier == _displayTiers[i],
              onTap: () {
                onSelected(
                  selectedTier == _displayTiers[i] ? null : _displayTiers[i],
                );
              },
            ),
          ),
          if (i != _displayTiers.length - 1)
            const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}

const _displayTiers = [SeatTier.gold, SeatTier.silver, SeatTier.bronze];

class _SeatTierCard extends StatelessWidget {
  const _SeatTierCard({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final SeatTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColorFor(tier);

    return Semantics(
      button: true,
      selected: selected,
      label: '${tier.label} seats',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 96,
            padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: selected ? AppColors.elevatedSurface : AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: selected ? accentColor : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_iconFor(tier), color: accentColor),
                const Spacer(),
                Text(
                  tier.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  selected ? 'Selected' : 'Tap to filter',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

Color _accentColorFor(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => AppColors.primaryYellow,
    SeatTier.silver => AppColors.textSecondary,
    SeatTier.bronze => AppColors.darkYellow,
    SeatTier.unknown => AppColors.borderStrong,
  };
}

IconData _iconFor(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => Icons.workspace_premium_rounded,
    SeatTier.silver => Icons.star_half_rounded,
    SeatTier.bronze => Icons.shield_rounded,
    SeatTier.unknown => Icons.event_seat_rounded,
  };
}
