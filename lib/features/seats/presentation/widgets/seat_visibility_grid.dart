import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';

class SeatVisibilityGrid extends StatelessWidget {
  const SeatVisibilityGrid({super.key, required this.seats});

  final List<Seat> seats;

  @override
  Widget build(BuildContext context) {
    final sortedSeats = List<Seat>.of(seats)
      ..sort((a, b) {
        final tierCompare = _tierOrder(a.tier).compareTo(_tierOrder(b.tier));
        if (tierCompare != 0) {
          return tierCompare;
        }
        return a.position.compareTo(b.position);
      });

    return PromooCard(
      color: AppColors.elevatedSurface,
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: AppColors.brandBlack,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visibility grid',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      'Quick view of current Promoo placement slots.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (sortedSeats.isEmpty)
            Text(
              'Seats will appear here when placements are available.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final seat in sortedSeats) _SeatGridSlot(seat: seat),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _GridLegendItem(
                label: 'Available',
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
              ),
              _GridLegendItem(
                label: 'Pending',
                icon: Icons.hourglass_empty_rounded,
                color: AppColors.warning,
              ),
              _GridLegendItem(
                label: 'Booked',
                icon: Icons.lock_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatGridSlot extends StatelessWidget {
  const _SeatGridSlot({required this.seat});

  final Seat seat;

  @override
  Widget build(BuildContext context) {
    final tierColor = _tierColor(seat.tier);
    final statusIcon = _statusIcon(seat.status);
    final statusColor = _statusColor(seat.status);
    final borderColor = seat.isAvailable ? tierColor : AppColors.borderStrong;

    return Tooltip(
      message: '${seat.title} - ${seat.status.label}',
      child: Container(
        width: 58,
        height: 64,
        padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _tierInitial(seat.tier),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: tierColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '#${seat.position}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Icon(statusIcon, color: statusColor, size: 15),
          ],
        ),
      ),
    );
  }
}

class _GridLegendItem extends StatelessWidget {
  const _GridLegendItem({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: AppSpacing.xxs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

int _tierOrder(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => 0,
    SeatTier.silver => 1,
    SeatTier.bronze => 2,
    SeatTier.unknown => 3,
  };
}

String _tierInitial(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => 'G',
    SeatTier.silver => 'S',
    SeatTier.bronze => 'B',
    SeatTier.unknown => '-',
  };
}

Color _tierColor(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => AppColors.primaryYellow,
    SeatTier.silver => AppColors.textSecondary,
    SeatTier.bronze => AppColors.darkYellow,
    SeatTier.unknown => AppColors.borderStrong,
  };
}

IconData _statusIcon(SeatStatus status) {
  return switch (status) {
    SeatStatus.available => Icons.check_circle_rounded,
    SeatStatus.pending => Icons.hourglass_empty_rounded,
    SeatStatus.booked => Icons.lock_rounded,
    SeatStatus.expired => Icons.schedule_rounded,
    SeatStatus.unknown => Icons.block_rounded,
  };
}

Color _statusColor(SeatStatus status) {
  return switch (status) {
    SeatStatus.available => AppColors.success,
    SeatStatus.pending => AppColors.warning,
    SeatStatus.booked => AppColors.textMuted,
    SeatStatus.expired => AppColors.textMuted,
    SeatStatus.unknown => AppColors.borderStrong,
  };
}
