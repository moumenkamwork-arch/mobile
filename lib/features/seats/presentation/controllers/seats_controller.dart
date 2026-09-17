import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/seats_repository_impl.dart';
import '../../domain/entities/seat.dart';

final seatsControllerProvider = NotifierProvider<SeatsController, SeatsState>(
  SeatsController.new,
);

enum SeatsStatus { loading, success, empty, error, refreshing }

enum SeatBookingStatus {
  idle,
  pending,
  authRequired,
  unavailable,
  success,
  error,
}

class SeatsState {
  const SeatsState({
    required this.status,
    this.seats = const [],
    this.selectedTier,
    this.failure,
    this.bookingStatus = SeatBookingStatus.idle,
    this.bookingSeatId,
    this.bookingResult,
    this.bookingFailure,
  });

  const SeatsState.loading() : this(status: SeatsStatus.loading);

  const SeatsState.success({
    required List<Seat> seats,
    SeatTier? selectedTier,
    SeatBookingStatus bookingStatus = SeatBookingStatus.idle,
    String? bookingSeatId,
    SeatBookingResult? bookingResult,
    AppFailure? bookingFailure,
  }) : this(
         status: SeatsStatus.success,
         seats: seats,
         selectedTier: selectedTier,
         bookingStatus: bookingStatus,
         bookingSeatId: bookingSeatId,
         bookingResult: bookingResult,
         bookingFailure: bookingFailure,
       );

  const SeatsState.empty({
    SeatTier? selectedTier,
    SeatBookingStatus bookingStatus = SeatBookingStatus.idle,
    String? bookingSeatId,
  }) : this(
         status: SeatsStatus.empty,
         selectedTier: selectedTier,
         bookingStatus: bookingStatus,
         bookingSeatId: bookingSeatId,
       );

  const SeatsState.error({
    required AppFailure failure,
    List<Seat> seats = const [],
    SeatTier? selectedTier,
  }) : this(
         status: SeatsStatus.error,
         failure: failure,
         seats: seats,
         selectedTier: selectedTier,
       );

  const SeatsState.refreshing({
    required List<Seat> seats,
    SeatTier? selectedTier,
    SeatBookingStatus bookingStatus = SeatBookingStatus.idle,
    String? bookingSeatId,
  }) : this(
         status: SeatsStatus.refreshing,
         seats: seats,
         selectedTier: selectedTier,
         bookingStatus: bookingStatus,
         bookingSeatId: bookingSeatId,
       );

  final SeatsStatus status;
  final List<Seat> seats;
  final SeatTier? selectedTier;
  final AppFailure? failure;
  final SeatBookingStatus bookingStatus;
  final String? bookingSeatId;
  final SeatBookingResult? bookingResult;
  final AppFailure? bookingFailure;

  bool get isRefreshing => status == SeatsStatus.refreshing;

  bool get hasContent => seats.isNotEmpty;
}

class SeatsController extends Notifier<SeatsState> {
  var _disposed = false;

  @override
  SeatsState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const SeatsState.loading();
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return _load(showLoading: true);
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  Future<void> selectTier(SeatTier? tier) {
    return _load(
      selectedTier: tier,
      updateSelectedTier: true,
      refreshing: true,
    );
  }

  void requestBooking(Seat seat) {
    if (!seat.isAvailable) {
      state = _copyWithBooking(SeatBookingStatus.unavailable, seatId: seat.id);
      return;
    }

    state = _copyWithBooking(SeatBookingStatus.authRequired, seatId: seat.id);
  }

  void clearBookingMessage() {
    state = _copyWithBooking(SeatBookingStatus.idle);
  }

  Future<void> bookSeatAfterAuth(String seatId) async {
    state = _copyWithBooking(SeatBookingStatus.pending, seatId: seatId);

    final repository = ref.read(seatsRepositoryProvider);
    final result = await repository.bookSeat(seatId);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (bookingResult) => _copyWithBooking(
        SeatBookingStatus.success,
        seatId: seatId,
        result: bookingResult,
      ),
      failure: (failure) => _copyWithBooking(
        SeatBookingStatus.error,
        seatId: seatId,
        failure: failure,
      ),
    );
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
    SeatTier? selectedTier,
    bool updateSelectedTier = false,
  }) async {
    final currentSeats = state.seats;
    final nextSelectedTier = updateSelectedTier
        ? selectedTier
        : state.selectedTier;

    if (refreshing) {
      state = SeatsState.refreshing(
        seats: currentSeats,
        selectedTier: nextSelectedTier,
      );
    } else if (showLoading) {
      state = const SeatsState.loading();
    }

    final repository = ref.read(seatsRepositoryProvider);
    final result = await repository.getSeats(tier: nextSelectedTier);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (seats) {
        if (seats.isEmpty) {
          return SeatsState.empty(selectedTier: nextSelectedTier);
        }
        return SeatsState.success(seats: seats, selectedTier: nextSelectedTier);
      },
      failure: (failure) {
        return SeatsState.error(
          failure: failure,
          seats: refreshing ? currentSeats : const [],
          selectedTier: nextSelectedTier,
        );
      },
    );
  }

  SeatsState _copyWithBooking(
    SeatBookingStatus bookingStatus, {
    String? seatId,
    SeatBookingResult? result,
    AppFailure? failure,
  }) {
    return SeatsState(
      status: state.status,
      seats: state.seats,
      selectedTier: state.selectedTier,
      failure: state.failure,
      bookingStatus: bookingStatus,
      bookingSeatId: seatId,
      bookingResult: result,
      bookingFailure: failure,
    );
  }
}
