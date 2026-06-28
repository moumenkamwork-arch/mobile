import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/home/presentation/controllers/home_content_detail_controller.dart';

void main() {
  test('emits loading then success', () async {
    const request = HomeContentDetailRequest(
      type: HomeContentDetailType.offer,
      id: 'offer-1',
    );
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          const _HomeRepository(
            detailResult: Result.success(
              HomeContentDetail(
                id: 'offer-1',
                type: HomeContentDetailType.offer,
                title: 'Cafe opening spotlight',
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(homeContentDetailControllerProvider(request)).status,
      HomeContentDetailStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeContentDetailControllerProvider(request));
    expect(state.status, HomeContentDetailStatus.success);
    expect(state.detail?.title, 'Cafe opening spotlight');
  });

  test('emits validation error for invalid request', () async {
    const request = HomeContentDetailRequest(
      type: HomeContentDetailType.unknown,
      id: '',
    );
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          const _HomeRepository(
            detailResult: Result.failure(
              AppFailure.unknown(message: 'Should not be called'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(homeContentDetailControllerProvider(request));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeContentDetailControllerProvider(request));
    expect(state.status, HomeContentDetailStatus.error);
    expect(state.failure?.message, 'Home detail is unavailable.');
  });

  test('emits repository failure', () async {
    const request = HomeContentDetailRequest(
      type: HomeContentDetailType.offer,
      id: 'missing',
    );
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          const _HomeRepository(
            detailResult: Result.failure(
              AppFailure.notFound(message: 'Offer not found'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(homeContentDetailControllerProvider(request));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeContentDetailControllerProvider(request));
    expect(state.status, HomeContentDetailStatus.error);
    expect(state.failure?.message, 'Offer not found');
  });
}

class _HomeRepository implements HomeRepository {
  const _HomeRepository({required this.detailResult});

  final Result<HomeContentDetail> detailResult;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    return const Result.success(HomeContent());
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return detailResult;
  }
}
