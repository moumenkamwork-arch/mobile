import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/seat.dart';
import '../dto/seats_dto.dart';
import 'seats_data_source.dart';

final seatsFakeDataSourceProvider = Provider<SeatsFakeDataSource>((ref) {
  return const SeatsFakeDataSource();
});

/// Demo seat map matching the original app's Influencer page: a large grid
/// of Gold (499 AED), Silver (299 AED), and Bronze (149 AED) placements with
/// fictional occupied influencer slots scattered between open seats.
///
/// Counts follow the grid bands used by the Seats screen (12x12 cells,
/// band size 4): 16 gold, 48 silver, 80 bronze = 144 seats total. The real
/// backend currently seeds fewer seats; expanding the seed is an
/// integration-phase task (see docs/build_plan.md Phase B row 2).
class SeatsFakeDataSource implements SeatsDataSource {
  const SeatsFakeDataSource();

  static const _tierCounts = {'gold': 16, 'silver': 48, 'bronze': 80};
  static const _tierPrices = {'gold': 499, 'silver': 299, 'bronze': 149};

  /// Occupied demo slots per tier: position -> (name, pravatar image id).
  static const _holders = {
    'gold': {
      1: ('Sara Fashion', 47),
      5: ('Hadi Coding', 12),
      7: ('Kareem Fitness', 59),
      10: ('Nour Lifestyle', 16),
      14: ('Ahmed Gamer', 68),
      16: ('Reem Makeup', 45),
    },
    'silver': {
      2: ('Lina Artworks', 44),
      5: ('Maya Art', 26),
      12: ('Noha MakeupGuru', 24),
      16: ('Majed Trips', 53),
      21: ('Nina Lifestyle', 40),
      27: ('Rami Tech', 61),
      28: ('Samah Artist', 21),
      33: ('Noor Books', 35),
      38: ('Nadia FoodQueen', 32),
      44: ('Dana Beauty', 20),
    },
    'bronze': {
      3: ('Rana Books', 41),
      9: ('Hamza Vlogger', 13),
      17: ('Maysa Cooking', 25),
      26: ('Nasser ScienceLab', 60),
      34: ('Hiba Fitness', 27),
      47: ('Adel Stories', 51),
      58: ('Rima BeautyLab', 23),
      66: ('Omar Pranks', 66),
    },
  };

  static final List<SeatDto> _seats = _buildSeats();

  static List<SeatDto> _buildSeats() {
    final seats = <SeatDto>[];
    for (final tier in _tierCounts.keys) {
      final count = _tierCounts[tier]!;
      final price = _tierPrices[tier]!;
      final holders = _holders[tier]!;
      for (var position = 1; position <= count; position++) {
        final holder = holders[position];
        seats.add(
          SeatDto(
            id: 'seat-$tier-$position',
            tier: tier,
            price: price,
            currency: 'AED',
            status: holder == null ? 'available' : 'booked',
            position: position,
            holder: holder == null
                ? null
                : SeatHolderDto(
                    id: 'profile-${holder.$1.toLowerCase().replaceAll(' ', '-')}',
                    name: holder.$1,
                    username: holder.$1.toLowerCase().replaceAll(' ', '.'),
                    avatarUrl: 'https://i.pravatar.cc/150?img=${holder.$2}',
                  ),
          ),
        );
      }
    }
    return List.unmodifiable(seats);
  }

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
