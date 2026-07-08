import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';
import 'seat_status_badge.dart';

class SeatCard extends StatelessWidget {
  const SeatCard({
    super.key,
    required this.seat,
    required this.onBookingRequested,
  });

  final Seat seat;
  final ValueChanged<Seat> onBookingRequested;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = _tierColor(seat.tier, colors);

    return PromooCard(
      borderColor: seat.isAvailable ? accentColor : colors.border,
      elevated: seat.tier == SeatTier.gold && seat.isAvailable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accentColor),
                ),
                child: Icon(_tierIcon(seat.tier), color: accentColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Position ${seat.position}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SeatStatusBadge(status: seat.status),
            ],
          ),
          if (seat.holder != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Held by ${seat.holder!.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Placement price',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      seat.price?.label ?? 'Contact for pricing',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: colors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PromooButton.secondary(
                label: _buttonLabelFor(seat.status),
                icon: seat.isAvailable
                    ? Icons.lock_outline_rounded
                    : Icons.block_rounded,
                onPressed: seat.isAvailable
                    ? () => onBookingRequested(seat)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _buttonLabelFor(SeatStatus status) {
  return switch (status) {
    SeatStatus.available => 'Login required',
    SeatStatus.pending => 'Pending',
    SeatStatus.booked => 'Booked',
    SeatStatus.expired => 'Expired',
    SeatStatus.unknown => 'Unavailable',
  };
}

Color _tierColor(SeatTier tier, AppThemeColors colors) {
  // Ink usage (icons/labels on surfaces): gold resolves to the theme accent
  // and bronze to the bronze ink so both stay readable on paper.
  return switch (tier) {
    SeatTier.gold => colors.accent,
    SeatTier.silver => colors.textSecondary,
    SeatTier.bronze =>
      colors == AppColors.dark ? colors.darkYellow : colors.warning,
    SeatTier.unknown => colors.borderStrong,
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
