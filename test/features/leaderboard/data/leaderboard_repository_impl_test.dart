import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/leaderboard/data/datasources/leaderboard_data_source.dart';
import 'package:promoo_app/features/leaderboard/data/dto/leaderboard_dto.dart';
import 'package:promoo_app/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:promoo_app/features/leaderboard/domain/entities/leaderboard_profile.dart';

void main() {
  test('uses fake data source when mock fallback is enabled', () async {
    final fakeDataSource = _RecordingDataSource(
      response: const LeaderboardProfilesDto([
        LeaderboardProfileDto(
          id: 'profile-saffron-social',
          rank: 1,
          displayName: 'Saffron Social Studio',
          followersCount: 100,
        ),
      ]),
    );
    final repository = LeaderboardRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: fakeDataSource,
    );

    final result = await repository.getLeaderboard(
      type: LeaderboardType.influencer,
    );

    expect(result.isSuccess, isTrue);
    expect(fakeDataSource.lastType, LeaderboardType.influencer);
    result.when(
      success: (profiles) {
        expect(profiles.single.id, 'profile-saffron-social');
        expect(profiles.single.displayName, 'Saffron Social Studio');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      response: const LeaderboardProfilesDto([
        LeaderboardProfileDto(
          id: 'profile-remote-leader',
          rank: 1,
          displayName: 'Remote Campaign Leader',
          followersCount: 250,
        ),
      ]),
    );
    final repository = LeaderboardRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getLeaderboard();

    expect(remoteDataSource.lastType, LeaderboardType.all);
    result.when(
      success: (profiles) =>
          expect(profiles.single.id, 'profile-remote-leader'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('maps API exceptions to failures', () async {
    final repository = LeaderboardRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.timeout,
          message: 'The request timed out.',
        ),
      ),
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getLeaderboard();

    expect(result.isFailure, isTrue);
    result.when(
      success: (profiles) => fail('Expected failure, got $profiles'),
      failure: (failure) => expect(failure.message, 'The request timed out.'),
    );
  });
}

class _RecordingDataSource implements LeaderboardDataSource {
  _RecordingDataSource({required this.response});

  final LeaderboardProfilesDto response;
  LeaderboardType? lastType;

  @override
  Future<LeaderboardProfilesDto> fetchLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) async {
    lastType = type;
    return response;
  }
}

class _ThrowingDataSource implements LeaderboardDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<LeaderboardProfilesDto> fetchLeaderboard({
    LeaderboardType type = LeaderboardType.all,
  }) {
    return Future<LeaderboardProfilesDto>.error(error);
  }
}
