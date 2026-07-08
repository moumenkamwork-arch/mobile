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
    final colors = context.colors;
    final accentColor = _statusColor(status, colors);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
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

Color _statusColor(SeatStatus status, AppThemeColors colors) {
  return switch (status) {
    SeatStatus.available => colors.success,
    SeatStatus.pending => colors.warning,
    SeatStatus.booked => colors.textMuted,
    SeatStatus.expired => colors.error,
    SeatStatus.unknown => colors.textMuted,
  };
}
