import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';
import '../controllers/seats_controller.dart';
import '../widgets/seat_booking_notice.dart';
import '../widgets/seat_card.dart';
import '../widgets/seat_tier_cards.dart';
import '../widgets/seat_tier_explainer.dart';
import '../widgets/seat_visibility_grid.dart';
import '../widgets/seats_premium_header.dart';

class SeatsScreen extends ConsumerWidget {
  const SeatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seatsControllerProvider);

    return switch (state.status) {
      SeatsStatus.loading => const PromooLoadingIndicator(
        message: 'Loading seats',
      ),
      SeatsStatus.error => _SeatsErrorView(state: state),
      SeatsStatus.empty ||
      SeatsStatus.success ||
      SeatsStatus.refreshing => _SeatsContentView(
        state: state,
        onRefresh: () => ref.read(seatsControllerProvider.notifier).refresh(),
      ),
    };
  }
}

class _SeatsErrorView extends ConsumerWidget {
  const _SeatsErrorView({required this.state});

  final SeatsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.hasContent) {
      return Stack(
        children: [
          _SeatsContentView(
            state: state,
            onRefresh: () =>
                ref.read(seatsControllerProvider.notifier).refresh(),
          ),
          PositionedDirectional(
            top: AppSpacing.md,
            start: AppSpacing.md,
            end: AppSpacing.md,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  state.failure?.message ?? 'Could not refresh seats.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return PromooErrorState(
      title: 'Could not load seats',
      message: state.failure?.message ?? 'Something went wrong. Try again.',
      onRetry: () => ref.read(seatsControllerProvider.notifier).retry(),
    );
  }
}

class _SeatsContentView extends ConsumerWidget {
  const _SeatsContentView({required this.state, required this.onRefresh});

  final SeatsState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primaryYellow,
          backgroundColor: AppColors.elevatedSurface,
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.screenVertical,
                  AppSpacing.screenHorizontal,
                  AppSpacing.shellScrollBottom,
                ),
                sliver: SliverList.list(
                  children: [
                    SeatsPremiumHeader(seats: state.seats),
                    const SizedBox(height: AppSpacing.lg),
                    const SeatTierExplainer(),
                    const SizedBox(height: AppSpacing.lg),
                    SeatVisibilityGrid(
                      seats: state.seats,
                      onSeatSelected: (seat) =>
                          _showSeatPreviewSheet(context, seat),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PromooSectionHeader(
                      title: 'Browse placements',
                      subtitle: state.selectedTier == null
                          ? 'Filter by Gold, Silver, or Bronze visibility'
                          : '${state.selectedTier!.label} seats selected',
                      actionLabel: state.selectedTier == null ? null : 'Clear',
                      onActionPressed: state.selectedTier == null
                          ? null
                          : () => ref
                                .read(seatsControllerProvider.notifier)
                                .selectTier(null),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SeatTierCards(
                      selectedTier: state.selectedTier,
                      onSelected: (tier) => ref
                          .read(seatsControllerProvider.notifier)
                          .selectTier(tier),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SeatBookingNotice(
                      status: state.bookingStatus,
                      failureMessage: state.bookingFailure?.message,
                      onLoginPressed: () => context.go(AppRoutes.login),
                      onDismiss: state.bookingStatus == SeatBookingStatus.idle
                          ? null
                          : () => ref
                                .read(seatsControllerProvider.notifier)
                                .clearBookingMessage(),
                    ),
                    if (state.bookingStatus != SeatBookingStatus.idle)
                      const SizedBox(height: AppSpacing.lg),
                    if (state.seats.isEmpty)
                      _SeatsEmptyState(selectedTier: state.selectedTier)
                    else
                      _SeatsList(seats: state.seats),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.isRefreshing)
          const PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

class _SeatsList extends ConsumerWidget {
  const _SeatsList({required this.seats});

  final List<Seat> seats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (var i = 0; i < seats.length; i++) ...[
          SeatCard(
            seat: seats[i],
            onBookingRequested: (seat) {
              ref.read(seatsControllerProvider.notifier).requestBooking(seat);
            },
          ),
          if (i != seats.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _SeatsEmptyState extends StatelessWidget {
  const _SeatsEmptyState({required this.selectedTier});

  final SeatTier? selectedTier;

  @override
  Widget build(BuildContext context) {
    return PromooEmptyState(
      title: selectedTier == null
          ? 'No seats yet'
          : 'No ${selectedTier!.label} seats',
      message: selectedTier == null
          ? 'Premium seats will appear here when they are available.'
          : 'Try another tier or clear the tier filter.',
      icon: Icons.event_seat_rounded,
    );
  }
}

void _showSeatPreviewSheet(BuildContext context, Seat seat) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _SeatPreviewSheet(
        seat: seat,
        onViewProfile: seat.holder == null
            ? null
            : () {
                Navigator.of(sheetContext).pop();
                context.go(AppRoutes.profileById(seat.holder!.id));
              },
        onBookNow: !seat.isAvailable
            ? null
            : () {
                Navigator.of(sheetContext).pop();
                context.go(
                  AppRoutes.seatCheckout(
                    seatId: seat.id,
                    title: seat.title,
                    tier: '${seat.tier.label} visibility placement',
                    price: seat.price?.label ?? '',
                  ),
                );
              },
      );
    },
  );
}

class _SeatPreviewSheet extends StatelessWidget {
  const _SeatPreviewSheet({
    required this.seat,
    this.onViewProfile,
    this.onBookNow,
  });

  final Seat seat;
  final VoidCallback? onViewProfile;
  final VoidCallback? onBookNow;

  @override
  Widget build(BuildContext context) {
    final holder = seat.holder;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            end: AppSpacing.md,
            bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
          ),
          child: PromooCard(
            key: const ValueKey('seat-preview-sheet'),
            color: AppColors.elevatedSurface,
            borderColor: seat.isAvailable
                ? AppColors.primaryYellow
                : AppColors.borderStrong,
            padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
            child: holder == null
                ? _AvailableSeatPreview(seat: seat, onBookNow: onBookNow)
                : _OccupiedSeatPreview(
                    seat: seat,
                    holder: holder,
                    onViewProfile: onViewProfile,
                  ),
          ),
        ),
      ),
    );
  }
}

class _OccupiedSeatPreview extends StatelessWidget {
  const _OccupiedSeatPreview({
    required this.seat,
    required this.holder,
    this.onViewProfile,
  });

  final Seat seat;
  final SeatHolder holder;
  final VoidCallback? onViewProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SheetHandle(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.brandBlack,
                shape: BoxShape.circle,
                border: Border.all(color: _tierColor(seat.tier), width: 2),
              ),
              child: ClipOval(
                child: PromooImage(
                  imageUrl: holder.avatarUrl,
                  fallbackIcon: Icons.person_rounded,
                  semanticLabel: holder.name,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holder.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    holder.username == null
                        ? seat.title
                        : '@${holder.username}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _PreviewChip(label: '${seat.tier.label} placement'),
                      _PreviewChip(label: seat.status.label),
                      _PreviewChip(label: _audienceLabel(holder.id)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _bioFor(holder.id),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: PromooButton.secondary(
                label: 'Follow',
                icon: Icons.person_add_alt_1_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Follow action coming soon'),
                      ),
                    );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PromooButton.primary(
                label: 'View profile',
                icon: Icons.arrow_forward_rounded,
                onPressed: onViewProfile,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvailableSeatPreview extends StatelessWidget {
  const _AvailableSeatPreview({required this.seat, this.onBookNow});

  final Seat seat;
  final VoidCallback? onBookNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SheetHandle(),
        Row(
          children: [
            Container(
              width: 62,
              height: 62,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tierColor(seat.tier).withValues(alpha: 0.13),
                shape: BoxShape.circle,
                border: Border.all(color: _tierColor(seat.tier)),
              ),
              child: Icon(
                Icons.event_seat_rounded,
                color: _tierColor(seat.tier),
                size: 30,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seat.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    seat.price?.label ?? 'Price shown after selection',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryYellow,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '${seat.tier.label} placement gives your profile stronger visibility in the Influencer Seats area.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _PreviewChip(label: _visibilityLabel(seat.tier)),
            const _PreviewChip(label: 'Profile spotlight'),
            const _PreviewChip(label: 'Placement preview'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        PromooButton.primary(
          label: 'Book Now',
          icon: Icons.lock_rounded,
          fullWidth: true,
          onPressed: onBookNow,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'This opens a checkout preview for the walkthrough. Real booking remains safe until login and payment are enabled.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        width: 42,
        height: 4,
        margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.borderStrong,
          borderRadius: AppRadius.pill,
        ),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

String _audienceLabel(String id) {
  return switch (id) {
    'profile-saffron-social' => '185K followers',
    'profile-lina-atelier' => '143K followers',
    'profile-framehouse' => '98K followers',
    'profile-pearl-cafe' => '72K followers',
    'profile-velvet-beauty' => '65K followers',
    _ => 'Growing audience',
  };
}

String _bioFor(String id) {
  return switch (id) {
    'profile-saffron-social' =>
      'Premium launch campaigns and creator visibility for brands across the UAE.',
    'profile-lina-atelier' =>
      'Lifestyle creator focused on polished hospitality, style, and wellness moments.',
    'profile-framehouse' =>
      'Event visuals and product photography for memorable brand launches.',
    'profile-pearl-cafe' =>
      'Cafe discovery, seasonal offers, and community launch content.',
    'profile-velvet-beauty' =>
      'Beauty and wellness campaigns with polished self-care storytelling.',
    _ => 'Promoo creator with active campaign visibility.',
  };
}

String _visibilityLabel(SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => 'Highest visibility',
    SeatTier.silver => 'Strong placement',
    SeatTier.bronze => 'Starter visibility',
    SeatTier.unknown => 'Visibility placement',
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
