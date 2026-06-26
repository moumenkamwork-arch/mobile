import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Future<SeatBookingResultDto> bookSeat(String seatId) async {
    final response = await _apiClient.post<SeatBookingResultDto>(
      ApiEndpoints.bookSeat(seatId),
      decode: SeatBookingResultDto.fromJsonFlexible,
    );

    return response.data ?? const SeatBookingResultDto();
  }
}
