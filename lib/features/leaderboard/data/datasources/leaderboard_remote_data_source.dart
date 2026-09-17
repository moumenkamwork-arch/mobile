import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/leaderboard_profile.dart';
import '../dto/leaderboard_dto.dart';
import 'leaderboard_data_source.dart';

final leaderboardRemoteDataSourceProvider =
    Provider<LeaderboardRemoteDataSource>((ref) {
      return LeaderboardRemoteDataSource(ref.watch(apiClientProvider));
    });

class LeaderboardRemoteDataSource implements LeaderboardDataSource {
  const LeaderboardRemoteDataSource(this._apiClient);

  static const _firstPage = 1;
  static const _pageLimit = 20;

  final ApiClient _apiClient;

  @override
  Future<LeaderboardProfilesDto> fetchLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    final response = await _apiClient.get<LeaderboardProfilesDto>(
      ApiEndpoints.leaderboard,
      queryParameters: {
        'page': _firstPage,
        'limit': _pageLimit,
        'type': type.apiValue,
      },
      decode: LeaderboardProfilesDto.fromJsonFlexible,
    );

    return response.data ?? LeaderboardProfilesDto.empty();
  }
}
