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
      currency: 'AED',
      status: 'booked',
      position: 1,
      holder: SeatHolderDto(
        id: 'profile-saffron-social',
        name: 'Saffron Social Studio',
        username: 'saffron.social',
        avatarUrl:
            'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=320&q=80',
      ),
    ),
    SeatDto(
      id: 'seat-gold-2',
      tier: 'gold',
      price: 2500,
      currency: 'AED',
      status: 'available',
      position: 2,
    ),
    SeatDto(
      id: 'seat-gold-3',
      tier: 'gold',
      price: 2500,
      currency: 'AED',
      status: 'pending',
      position: 3,
      holder: SeatHolderDto(
        id: 'profile-framehouse',
        name: 'Framehouse Events',
        username: 'framehouse.events',
        avatarUrl:
            'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&w=320&q=80',
      ),
    ),
    SeatDto(
      id: 'seat-silver-1',
      tier: 'silver',
      price: 1500,
      currency: 'AED',
      status: 'booked',
      position: 1,
      holder: SeatHolderDto(
        id: 'profile-lina-atelier',
        name: 'Lina Atelier',
        username: 'lina.atelier',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=320&q=80',
      ),
    ),
    SeatDto(
      id: 'seat-silver-2',
      tier: 'silver',
      price: 1500,
      currency: 'AED',
      status: 'available',
      position: 2,
    ),
    SeatDto(
      id: 'seat-silver-3',
      tier: 'silver',
      price: 1500,
      currency: 'AED',
      status: 'booked',
      position: 3,
      holder: SeatHolderDto(
        id: 'profile-pearl-cafe',
        name: 'Pearl District Cafe',
        username: 'pearl.district',
        avatarUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=320&q=80',
      ),
    ),
    SeatDto(
      id: 'seat-silver-4',
      tier: 'silver',
      price: 1500,
      currency: 'AED',
      status: 'available',
      position: 4,
    ),
    SeatDto(
      id: 'seat-bronze-1',
      tier: 'bronze',
      price: 900,
      currency: 'AED',
      status: 'available',
      position: 1,
    ),
    SeatDto(
      id: 'seat-bronze-2',
      tier: 'bronze',
      price: 900,
      currency: 'AED',
      status: 'booked',
      position: 2,
      holder: SeatHolderDto(
        id: 'profile-velvet-beauty',
        name: 'Velvet Beauty Lounge',
        username: 'velvet.beauty',
        avatarUrl:
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=320&q=80',
      ),
    ),
    SeatDto(
      id: 'seat-bronze-3',
      tier: 'bronze',
      price: 900,
      currency: 'AED',
      status: 'available',
      position: 3,
    ),
    SeatDto(
      id: 'seat-bronze-4',
      tier: 'bronze',
      price: 900,
      currency: 'AED',
      status: 'available',
      position: 4,
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
      sessionId: 'seat-hold-$seatId',
      status: 'pending',
    );
  }
}
