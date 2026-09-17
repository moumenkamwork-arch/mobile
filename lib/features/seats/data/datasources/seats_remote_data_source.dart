import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/seat.dart';
import '../dto/seats_dto.dart';
import 'seats_data_source.dart';

final seatsRemoteDataSourceProvider = Provider<SeatsRemoteDataSource>((ref) {
  return SeatsRemoteDataSource(ref.watch(apiClientProvider));
});

class SeatsRemoteDataSource implements SeatsDataSource {
  const SeatsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SeatsDto> fetchSeats({SeatTier? tier}) async {
    final queryParameters = <String, Object?>{
      if (tier?.apiValue != null) 'tier': tier!.apiValue,
    };

    final response = await _apiClient.get<SeatsDto>(
      ApiEndpoints.seats,
      queryParameters: queryParameters,
      decode: SeatsDto.fromJsonFlexible,
    );

    return response.data ?? SeatsDto.empty();
  }

  @override
  Future<SeatsDto> fetchMySeats() async {
    final response = await _apiClient.get<SeatsDto>(
      ApiEndpoints.mySeats,
      decode: SeatsDto.fromJsonFlexible,
    );

    return response.data ?? SeatsDto.empty();
  }

  @override
  Future<SeatBookingResultDto> bookSeat(String seatId) {
    // Booking is a Stripe-gated action deferred to v2 (see
    // docs/v2_deferred_scope.md §1 + project_rules §4: payments never originate
    // from the app in v1). The v1 UI's "Book Now" opens a local checkout
    // preview and never calls this — it is intentionally unreachable here. If
    // something does call it, fail loudly rather than silently start a real
    // Stripe checkout + reserve the seat.
    throw const AppFailure.unknown(
      message: 'Seat booking is not available in this version.',
    );
  }
}
