import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/seats/data/dto/seats_dto.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';

void main() {
  test('parses seats list fixture defensively', () {
    final dto = SeatsDto.fromJsonFlexible({
      'success': true,
      'data': [
        {
          'id': 'seat-1',
          'tier': 'gold',
          'price': 2500,
          'status': 'available',
          'position': 1,
          'profile': {
            'id': 'profile-1',
            'full_name': 'Noura Studio',
            'username': 'noura.studio',
            'avatar_url': 'https://example.com/avatar.png',
          },
        },
      ],
    });

    final seats = dto.toDomain(fallbackCurrency: 'AED');

    expect(seats.single.id, 'seat-1');
    expect(seats.single.tier, SeatTier.gold);
    expect(seats.single.status, SeatStatus.available);
    expect(seats.single.position, 1);
    expect(seats.single.price?.label, '2500 AED');
    expect(seats.single.holder?.name, 'Noura Studio');
  });

  test('parses direct and nested variants with unknown values', () {
    final dto = SeatsDto.fromJsonFlexible({
      'data': {
        'items': [
          {
            'seatId': 'seat-2',
            'seatTier': 'platinum',
            'amount': '900.50',
            'currency': 'usd',
            'seatStatus': 'held',
            'slot': '3',
          },
        ],
      },
    });

    final seat = dto.toDomain(fallbackCurrency: 'AED').single;

    expect(seat.id, 'seat-2');
    expect(seat.tier, SeatTier.unknown);
    expect(seat.status, SeatStatus.unknown);
    expect(seat.position, 3);
    expect(seat.price?.label, '900.50 USD');
  });

  test('parses booking response fixture', () {
    final dto = SeatBookingResultDto.fromJsonFlexible({
      'success': true,
      'data': {
        'checkoutUrl': 'https://checkout.example/session',
        'sessionId': 'cs_test_123',
        'paymentId': 'pi_123',
        'status': 'pending',
      },
    });

    final result = dto.toDomain();

    expect(result.checkoutUrl, 'https://checkout.example/session');
    expect(result.sessionId, 'cs_test_123');
    expect(result.paymentId, 'pi_123');
    expect(result.status, SeatStatus.pending);
    expect(result.hasCheckoutUrl, isTrue);
  });
}
