import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';

class SeatStatusBadge extends StatelessWidget {
  const SeatStatusBadge({super.key, required this.status});

  final SeatStatus status;

  @override
  Widget build(BuildContext context) {
    final accentColor = _statusColor(status);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: accentColor),
      ),
      child: Text(
        status.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: accentColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Color _statusColor(SeatStatus status) {
  return switch (status) {
    SeatStatus.available => AppColors.success,
    SeatStatus.pending => AppColors.warning,
    SeatStatus.booked => AppColors.textMuted,
    SeatStatus.expired => AppColors.error,
    SeatStatus.unknown => AppColors.textMuted,
  };
}
