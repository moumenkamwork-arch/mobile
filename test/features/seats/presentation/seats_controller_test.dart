import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';
import 'package:promoo_app/features/seats/domain/repositories/seats_repository.dart';
import 'package:promoo_app/features/seats/presentation/controllers/seats_controller.dart';

void main() {
  test('emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        seatsRepositoryProvider.overrideWithValue(
          const _SeatsRepository(
            seatsResult: Result.success([
              Seat(
                id: 'seat-1',
                tier: SeatTier.gold,
                status: SeatStatus.available,
                position: 1,
              ),
            ]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(seatsControllerProvider).status, SeatsStatus.loading);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(seatsControllerProvider);
    expect(state.status, SeatsStatus.success);
    expect(state.seats.single.tier, SeatTier.gold);
  });

  test('emits empty when repository returns no seats', () async {
    final container = ProviderContainer(
      overrides: [
        seatsRepositoryProvider.overrideWithValue(
          const _SeatsRepository(seatsResult: Result.success([])),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(seatsControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(seatsControllerProvider);
    expect(state.status, SeatsStatus.empty);
    expect(state.seats, isEmpty);
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        seatsRepositoryProvider.overrideWithValue(
          const _SeatsRepository(
            seatsResult: Result.failure(
              AppFailure.network(message: 'No connection'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(seatsControllerProvider).status, SeatsStatus.loading);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(seatsControllerProvider);
    expect(state.status, SeatsStatus.error);
    expect(state.failure?.message, 'No connection');
  });

  test('updates selected tier and sends auth-required booking state', () async {
    final repository = _SeatsRepository(
      seatsResult: const Result.success([
        Seat(
          id: 'seat-1',
          tier: SeatTier.gold,
          status: SeatStatus.available,
          position: 1,
        ),
      ]),
    );
    final container = ProviderContainer(
      overrides: [seatsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(seatsControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(seatsControllerProvider.notifier)
        .selectTier(SeatTier.gold);
    final filteredState = container.read(seatsControllerProvider);
    expect(filteredState.selectedTier, SeatTier.gold);
    expect(repository.lastTier, SeatTier.gold);

    container
        .read(seatsControllerProvider.notifier)
        .requestBooking(filteredState.seats.single);
    final bookingState = container.read(seatsControllerProvider);
    expect(bookingState.bookingStatus, SeatBookingStatus.authRequired);
    expect(bookingState.bookingSeatId, 'seat-1');
  });
}

class _SeatsRepository implements SeatsRepository {
  const _SeatsRepository({required this.seatsResult});

  final Result<List<Seat>> seatsResult;
  static const mySeatsResult = Result.success(<Seat>[]);

  SeatTier? get lastTier => _lastTier;
  static SeatTier? _lastTier;

  @override
  Future<Result<List<Seat>>> getSeats({SeatTier? tier}) async {
    _lastTier = tier;
    return seatsResult;
  }

  @override
  Future<Result<List<Seat>>> getMySeats() async {
    return mySeatsResult;
  }

  @override
  Future<Result<SeatBookingResult>> bookSeat(String seatId) async {
    return const Result.success(SeatBookingResult(status: SeatStatus.pending));
  }
}
