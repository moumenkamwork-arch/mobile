import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/controllers/services_controller.dart';

void main() {
  test('emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(
          _ServicesRepository(
            categoriesResult: const Result.success([
              ServiceCategory(id: 'cat-1', name: 'Marketing'),
            ]),
            servicesResult: const Result.success([
              PromooService(id: 'service-1', title: 'Content package'),
            ]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(servicesControllerProvider).status,
      ServicesStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(servicesControllerProvider);
    expect(state.status, ServicesStatus.success);
    expect(state.categories.single.name, 'Marketing');
    expect(state.services.single.title, 'Content package');
  });

  test('updates selected category and search query', () async {
    final repository = _ServicesRepository(
      categoriesResult: const Result.success([
        ServiceCategory(id: 'cat-1', name: 'Marketing'),
      ]),
      servicesResult: const Result.success([
        PromooService(id: 'service-1', title: 'Content package'),
      ]),
    );
    final container = ProviderContainer(
      overrides: [servicesRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(servicesControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(servicesControllerProvider.notifier)
        .selectCategory('cat-1');
    await container.read(servicesControllerProvider.notifier).search('video');

    final state = container.read(servicesControllerProvider);
    expect(state.selectedCategoryId, 'cat-1');
    expect(state.searchQuery, 'video');
    expect(repository.lastCategoryId, 'cat-1');
    expect(repository.lastQuery, 'video');
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(
          _ServicesRepository(
            categoriesResult: Result.failure(
              AppFailure.network(message: 'No connection'),
            ),
            servicesResult: Result.success([]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(servicesControllerProvider).status,
      ServicesStatus.loading,
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(servicesControllerProvider);
    expect(state.status, ServicesStatus.error);
    expect(state.failure?.message, 'No connection');
  });
}

class _ServicesRepository implements ServicesRepository {
  _ServicesRepository({
    required this.categoriesResult,
    required this.servicesResult,
  });

  final Result<List<ServiceCategory>> categoriesResult;
  final Result<List<PromooService>> servicesResult;
  static const detailResult = Result.success(
    PromooService(id: 'service-detail', title: 'Service detail'),
  );

  String? lastCategoryId;
  String? lastQuery;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    return categoriesResult;
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) async {
    lastCategoryId = categoryId;
    lastQuery = query;
    return servicesResult;
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    return detailResult;
  }
}
