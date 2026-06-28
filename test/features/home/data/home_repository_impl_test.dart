import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/home/data/datasources/home_data_source.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';

void main() {
  test('returns fake home content when mock fallback is enabled', () async {
    final repository = HomeRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: _StaticDataSource(HomeContentDto.fixture()),
    );

    final result = await repository.getHomeContent();

    expect(result.isSuccess, isTrue);
    result.when(
      success: (content) {
        expect(content.highlight?.title, 'Boutique launch visibility pack');
        expect(content.categories, isNotEmpty);
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('returns fake home detail when mock fallback is enabled', () async {
    final repository = HomeRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: const _StaticDataSource(
        HomeContentDto(),
        detailDto: HomeContentDetailDto(
          id: 'offer-1',
          type: HomeContentDetailType.offer,
          title: 'Cafe opening spotlight',
          price: 1500,
        ),
      ),
    );

    final result = await repository.getHomeContentDetail(
      const HomeContentDetailRequest(
        type: HomeContentDetailType.offer,
        id: 'offer-1',
      ),
    );

    expect(result.isSuccess, isTrue);
    result.when(
      success: (detail) {
        expect(detail.title, 'Cafe opening spotlight');
        expect(detail.price?.label, '1500 AED');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test(
    'loads detail through remote data source when mocks are disabled',
    () async {
      final remote = const _StaticDataSource(
        HomeContentDto(),
        detailDto: HomeContentDetailDto(
          id: 'ad-1',
          type: HomeContentDetailType.ad,
          title: 'Featured campaign spotlight',
        ),
      );
      final repository = HomeRepositoryImpl(
        config: const AppConfig(
          environment: AppEnvironment.development,
          baseUrl: AppConfig.defaultDevelopmentBaseUrl,
          useMocks: false,
        ),
        remoteDataSource: remote,
        fakeDataSource: _ThrowingDataSource(),
      );

      final result = await repository.getHomeContentDetail(
        const HomeContentDetailRequest(
          type: HomeContentDetailType.ad,
          id: 'ad-1',
        ),
      );

      expect(result.isSuccess, isTrue);
      result.when(
        success: (detail) =>
            expect(detail.title, 'Featured campaign spotlight'),
        failure: (failure) => fail('Expected success, got $failure'),
      );
    },
  );

  test('maps API exceptions to failures', () async {
    final repository = HomeRepositoryImpl(
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
      fakeDataSource: _StaticDataSource(HomeContentDto.fixture()),
    );

    final result = await repository.getHomeContent();

    expect(result.isFailure, isTrue);
    result.when(
      success: (content) => fail('Expected failure, got $content'),
      failure: (failure) => expect(failure.message, 'The request timed out.'),
    );
  });
}

class _StaticDataSource implements HomeDataSource {
  const _StaticDataSource(this.dto, {this.detailDto});

  final HomeContentDto dto;
  final HomeContentDetailDto? detailDto;

  @override
  Future<HomeContentDto> fetchHomeContent() async {
    return dto;
  }

  @override
  Future<HomeContentDetailDto> fetchHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return detailDto ??
        (throw const ApiException(
          type: ApiExceptionType.notFound,
          message: 'Home item not found.',
        ));
  }
}

class _ThrowingDataSource implements HomeDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Remote used'),
  ]);

  final Object error;

  @override
  Future<HomeContentDto> fetchHomeContent() {
    return Future<HomeContentDto>.error(error);
  }

  @override
  Future<HomeContentDetailDto> fetchHomeContentDetail(
    HomeContentDetailRequest request,
  ) {
    return Future<HomeContentDetailDto>.error(error);
  }
}
