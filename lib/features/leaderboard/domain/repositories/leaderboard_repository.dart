import '../../../../core/utils/result.dart';
import '../entities/leaderboard_profile.dart';

abstract interface class LeaderboardRepository {
  Future<Result<List<LeaderboardProfile>>> getLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  });
}
