import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/leaderboard_profile.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_data_source.dart';
import '../datasources/leaderboard_fake_data_source.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepositoryImpl(
    dataSource: ref.watch(leaderboardFakeDataSourceProvider),
  );
});

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl({required this.dataSource});

  final LeaderboardDataSource dataSource;

  @override
  Future<Result<List<LeaderboardProfile>>> getLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    try {
      final dto = await dataSource.fetchLeaderboard(type: type);
      return Result.success(dto.toDomain());
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
