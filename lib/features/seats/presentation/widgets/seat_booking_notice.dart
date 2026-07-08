import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/seats_controller.dart';

class SeatBookingNotice extends StatelessWidget {
  const SeatBookingNotice({
    super.key,
    required this.status,
    this.failureMessage,
    this.onDismiss,
    this.onLoginPressed,
  });

  final SeatBookingStatus status;
  final String? failureMessage;
  final VoidCallback? onDismiss;
  final VoidCallback? onLoginPressed;

  @override
  Widget build(BuildContext context) {
    if (status == SeatBookingStatus.idle) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final content = _contentFor(status, failureMessage, colors);

    return PromooCard(
      color: colors.elevatedSurface,
      borderColor: content.color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(content.icon, color: content.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  content.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (content.showLoginAction && onLoginPressed != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PromooButton.secondary(
                    label: 'Go to login',
                    icon: Icons.login_rounded,
                    onPressed: onLoginPressed,
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              tooltip: 'Dismiss',
              onPressed: onDismiss,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

_NoticeContent _contentFor(
  SeatBookingStatus status,
  String? failureMessage,
  AppThemeColors colors,
) {
  return switch (status) {
    SeatBookingStatus.authRequired => _NoticeContent(
      title: 'Login required',
      message: 'Sign in to continue when booking opens.',
      icon: Icons.lock_outline_rounded,
      color: colors.accent,
      showLoginAction: true,
    ),
    SeatBookingStatus.unavailable => _NoticeContent(
      title: 'Seat unavailable',
      message: 'This seat cannot be booked right now.',
      icon: Icons.block_rounded,
      color: colors.warning,
    ),
    SeatBookingStatus.pending => _NoticeContent(
      title: 'Booking pending',
      message: 'Preparing the booking request.',
      icon: Icons.hourglass_empty_rounded,
      color: colors.warning,
    ),
    SeatBookingStatus.success => _NoticeContent(
      title: 'Booking prepared',
      message: 'Your booking is ready. Payment will open in the next release.',
      icon: Icons.check_circle_outline_rounded,
      color: colors.success,
    ),
    SeatBookingStatus.error => _NoticeContent(
      title: 'Booking failed',
      message: failureMessage ?? 'Could not prepare booking.',
      icon: Icons.error_outline_rounded,
      color: colors.error,
    ),
    SeatBookingStatus.idle => _NoticeContent(
      title: '',
      message: '',
      icon: Icons.info_outline_rounded,
      color: colors.border,
    ),
  };
}

class _NoticeContent {
  const _NoticeContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.showLoginAction = false,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool showLoginAction;
}
