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
          id: 'fake-profile',
          rank: 1,
          displayName: 'Fake Leader',
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
        expect(profiles.single.id, 'fake-profile');
        expect(profiles.single.displayName, 'Fake Leader');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      response: const LeaderboardProfilesDto([
        LeaderboardProfileDto(
          id: 'remote-profile',
          rank: 1,
          displayName: 'Remote Leader',
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
      success: (profiles) => expect(profiles.single.id, 'remote-profile'),
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
