import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';

class SeatVisibilityGrid extends StatelessWidget {
  const SeatVisibilityGrid({
    super.key,
    required this.seats,
    this.onSeatSelected,
  });

  final List<Seat> seats;
  final ValueChanged<Seat>? onSeatSelected;

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
                      'Influencer visibility grid',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      'Tap a creator or open seat to preview the placement.',
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedSeats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.xs,
                mainAxisSpacing: AppSpacing.xs,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final seat = sortedSeats[index];
                return _SeatGridSlot(
                  seat: seat,
                  onTap: onSeatSelected == null
                      ? null
                      : () => onSeatSelected!(seat),
                );
              },
            ),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _GridLegendItem(
                label: 'Open seat',
                icon: Icons.event_available_rounded,
                color: AppColors.success,
              ),
              _GridLegendItem(
                label: 'Creator',
                icon: Icons.person_rounded,
                color: AppColors.primaryYellow,
              ),
              _GridLegendItem(
                label: 'Pending',
                icon: Icons.hourglass_empty_rounded,
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatGridSlot extends StatelessWidget {
  const _SeatGridSlot({required this.seat, this.onTap});

  final Seat seat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tierColor = _tierColor(seat.tier);
    final holder = seat.holder;
    final isOccupied = holder != null && !seat.isAvailable;

    return Semantics(
      button: true,
      label: isOccupied
          ? '${holder.name}, ${seat.title}'
          : 'Place Your Seat, ${seat.title}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('seat-grid-slot-${seat.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: seat.isAvailable
                  ? AppColors.surface
                  : AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: seat.isAvailable ? tierColor : AppColors.borderStrong,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: _TierBadge(label: seat.tier.label, color: tierColor),
                ),
                if (isOccupied)
                  _HolderAvatar(holder: holder, tierColor: tierColor)
                else
                  _AvailableSeatIcon(tierColor: tierColor),
                Column(
                  children: [
                    Text(
                      isOccupied ? holder.name : 'Place Your Seat',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      seat.isAvailable
                          ? seat.price?.label ?? seat.status.label
                          : seat.status.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: seat.isAvailable
                            ? AppColors.primaryYellow
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HolderAvatar extends StatelessWidget {
  const _HolderAvatar({required this.holder, required this.tierColor});

  final SeatHolder holder;
  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.brandBlack,
        shape: BoxShape.circle,
        border: Border.all(color: tierColor, width: 2),
      ),
      child: ClipOval(
        child: PromooImage(
          imageUrl: holder.avatarUrl,
          fallbackIcon: Icons.person_rounded,
          semanticLabel: holder.name,
        ),
      ),
    );
  }
}

class _AvailableSeatIcon extends StatelessWidget {
  const _AvailableSeatIcon({required this.tierColor});

  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tierColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: tierColor.withValues(alpha: 0.68)),
      ),
      child: Icon(Icons.event_seat_rounded, color: tierColor, size: 26),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
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

Color _tierColor(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => AppColors.primaryYellow,
    SeatTier.silver => AppColors.textSecondary,
    SeatTier.bronze => AppColors.darkYellow,
    SeatTier.unknown => AppColors.borderStrong,
  };
}
