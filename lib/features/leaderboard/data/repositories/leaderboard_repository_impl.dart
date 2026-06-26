import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/leaderboard_profile.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_data_source.dart';
import '../datasources/leaderboard_fake_data_source.dart';
import '../datasources/leaderboard_remote_data_source.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(leaderboardRemoteDataSourceProvider),
    fakeDataSource: ref.watch(leaderboardFakeDataSourceProvider),
  );
});

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final AppConfig config;
  final LeaderboardDataSource remoteDataSource;
  final LeaderboardDataSource fakeDataSource;

  LeaderboardDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<List<LeaderboardProfile>>> getLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    try {
      final dto = await _activeDataSource.fetchLeaderboard(type: type);
      return Result.success(dto.toDomain());
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
