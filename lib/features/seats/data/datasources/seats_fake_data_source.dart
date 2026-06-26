import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/seat.dart';
import '../dto/seats_dto.dart';
import 'seats_data_source.dart';

final seatsFakeDataSourceProvider = Provider<SeatsFakeDataSource>((ref) {
  return const SeatsFakeDataSource();
});

class SeatsFakeDataSource implements SeatsDataSource {
  const SeatsFakeDataSource();

  static const _seats = [
    SeatDto(
      id: 'seat-gold-1',
      tier: 'gold',
      price: 2500,
      status: 'available',
      position: 1,
    ),
    SeatDto(
      id: 'seat-gold-2',
      tier: 'gold',
      price: 2500,
      status: 'pending',
      position: 2,
      holder: SeatHolderDto(
        id: 'profile-noura',
        name: 'Noura Studio',
        username: 'noura.studio',
      ),
    ),
    SeatDto(
      id: 'seat-silver-1',
      tier: 'silver',
      price: 1500,
      status: 'available',
      position: 1,
    ),
    SeatDto(
      id: 'seat-silver-2',
      tier: 'silver',
      price: 1500,
      status: 'booked',
      position: 2,
      holder: SeatHolderDto(
        id: 'profile-omar',
        name: 'Omar Creative',
        username: 'omar.creative',
      ),
    ),
    SeatDto(
      id: 'seat-bronze-1',
      tier: 'bronze',
      price: 900,
      status: 'available',
      position: 1,
    ),
  ];

  @override
  Future<SeatsDto> fetchSeats({SeatTier? tier}) async {
    final seats = _seats
        .where((seat) {
          final requestedTier = tier?.apiValue;
          return requestedTier == null || seat.tier == requestedTier;
        })
        .toList(growable: false);

    return SeatsDto(seats);
  }

  @override
  Future<SeatsDto> fetchMySeats() async {
    return SeatsDto(
      _seats
          .where((seat) => seat.status == 'booked' || seat.status == 'pending')
          .toList(growable: false),
    );
  }

  @override
  Future<SeatBookingResultDto> bookSeat(String seatId) async {
    return SeatBookingResultDto(
      seatId: seatId,
      checkoutUrl: 'https://checkout.promoo.test/session/$seatId',
      sessionId: 'session-$seatId',
      paymentId: 'payment-$seatId',
      status: 'pending',
    );
  }
}
