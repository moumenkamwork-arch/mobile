import '../../../../core/utils/result.dart';
import '../entities/seat.dart';

abstract interface class SeatsRepository {
  Future<Result<List<Seat>>> getSeats({SeatTier? tier});

  Future<Result<List<Seat>>> getMySeats();

  Future<Result<SeatBookingResult>> bookSeat(String seatId);
}
