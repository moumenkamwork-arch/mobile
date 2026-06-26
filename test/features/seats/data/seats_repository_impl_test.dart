import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/seats/data/datasources/seats_data_source.dart';
import 'package:promoo_app/features/seats/data/dto/seats_dto.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';

void main() {
  test('uses fake data source when mock fallback is enabled', () async {
    final fakeDataSource = _RecordingDataSource(
      seats: const SeatsDto([
        SeatDto(
          id: 'fake-seat',
          tier: 'gold',
          price: 2500,
          status: 'available',
          position: 1,
        ),
      ]),
    );
    final repository = SeatsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: fakeDataSource,
    );

    final result = await repository.getSeats(tier: SeatTier.gold);

    expect(result.isSuccess, isTrue);
    expect(fakeDataSource.lastTier, SeatTier.gold);
    result.when(
      success: (seats) {
        expect(seats.single.id, 'fake-seat');
        expect(seats.single.price?.label, '2500 AED');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      seats: const SeatsDto([
        SeatDto(
          id: 'remote-seat',
          tier: 'silver',
          price: 1500,
          currency: 'usd',
          status: 'available',
          position: 2,
        ),
      ]),
    );
    final repository = SeatsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getSeats(tier: SeatTier.silver);

    expect(remoteDataSource.lastTier, SeatTier.silver);
    result.when(
      success: (seats) => expect(seats.single.price?.label, '1500 USD'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test(
    'maps booking response and passes seat id in path-level method',
    () async {
      final dataSource = _RecordingDataSource(
        seats: const SeatsDto([]),
        bookingResult: const SeatBookingResultDto(
          checkoutUrl: 'https://checkout.example/session',
          sessionId: 'session-1',
          status: 'pending',
        ),
      );
      final repository = SeatsRepositoryImpl(
        config: const AppConfig(
          environment: AppEnvironment.development,
          baseUrl: AppConfig.defaultDevelopmentBaseUrl,
          useMocks: false,
        ),
        remoteDataSource: dataSource,
        fakeDataSource: _ThrowingDataSource(),
      );

      final result = await repository.bookSeat('seat-123');

      expect(dataSource.lastBookedSeatId, 'seat-123');
      result.when(
        success: (booking) {
          expect(booking.sessionId, 'session-1');
          expect(booking.status, SeatStatus.pending);
        },
        failure: (failure) => fail('Expected success, got $failure'),
      );
    },
  );

  test('maps API exceptions to failures', () async {
    final repository = SeatsRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.unauthorized,
          message: 'Please sign in to continue.',
        ),
      ),
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getMySeats();

    expect(result.isFailure, isTrue);
    result.when(
      success: (seats) => fail('Expected failure, got $seats'),
      failure: (failure) {
        expect(failure.message, 'Please sign in to continue.');
      },
    );
  });
}

class _RecordingDataSource implements SeatsDataSource {
  _RecordingDataSource({
    required this.seats,
    this.bookingResult = const SeatBookingResultDto(),
  });

  final SeatsDto seats;
  final SeatBookingResultDto bookingResult;
  SeatTier? lastTier;
  String? lastBookedSeatId;

  @override
  Future<SeatsDto> fetchSeats({SeatTier? tier}) async {
    lastTier = tier;
    return seats;
  }

  @override
  Future<SeatsDto> fetchMySeats() async {
    return seats;
  }

  @override
  Future<SeatBookingResultDto> bookSeat(String seatId) async {
    lastBookedSeatId = seatId;
    return bookingResult;
  }
}

class _ThrowingDataSource implements SeatsDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<SeatsDto> fetchSeats({SeatTier? tier}) {
    return Future<SeatsDto>.error(error);
  }

  @override
  Future<SeatsDto> fetchMySeats() {
    return Future<SeatsDto>.error(error);
  }

  @override
  Future<SeatBookingResultDto> bookSeat(String seatId) {
    return Future<SeatBookingResultDto>.error(error);
  }
}
