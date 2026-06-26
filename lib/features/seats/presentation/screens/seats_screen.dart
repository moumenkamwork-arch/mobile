import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
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
                    SeatVisibilityGrid(seats: state.seats),
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
