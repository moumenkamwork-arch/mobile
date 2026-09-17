import '../../domain/entities/leaderboard_profile.dart';
import '../dto/leaderboard_dto.dart';

abstract interface class LeaderboardDataSource {
  Future<LeaderboardProfilesDto> fetchLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  });
}
