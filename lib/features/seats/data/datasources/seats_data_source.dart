import '../../domain/entities/seat.dart';
import '../dto/seats_dto.dart';

abstract interface class SeatsDataSource {
  Future<SeatsDto> fetchSeats({SeatTier? tier});

  Future<SeatsDto> fetchMySeats();

  Future<SeatBookingResultDto> bookSeat(String seatId);
}
