import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/controllers/service_detail_controller.dart';

void main() {
  test('emits loading then success for service detail', () async {
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(
          const _ServicesRepository(
            detailResult: Result.success(
              PromooService(
                id: 'service-influencer-launch',
                title: 'Boutique influencer launch package',
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container
          .read(serviceDetailControllerProvider('service-influencer-launch'))
          .status,
      ServiceDetailStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(
      serviceDetailControllerProvider('service-influencer-launch'),
    );
    expect(state.status, ServiceDetailStatus.success);
    expect(state.service?.id, 'service-influencer-launch');
  });

  test('emits error when service id is missing', () async {
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(
          const _ServicesRepository(
            detailResult: Result.success(
              PromooService(id: 'unused', title: 'Unused'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(serviceDetailControllerProvider(''));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(serviceDetailControllerProvider(''));
    expect(state.status, ServiceDetailStatus.error);
    expect(state.failure?.message, 'Service details are unavailable.');
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(
          const _ServicesRepository(
            detailResult: Result.failure(
              AppFailure.notFound(message: 'Service not found'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(serviceDetailControllerProvider('missing'));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(serviceDetailControllerProvider('missing'));
    expect(state.status, ServiceDetailStatus.error);
    expect(state.failure?.message, 'Service not found');
  });
}

class _ServicesRepository implements ServicesRepository {
  const _ServicesRepository({required this.detailResult});

  final Result<PromooService> detailResult;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    return const Result.success([]);
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) async {
    return const Result.success([]);
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    return detailResult;
  }
}
