import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/controllers/services_controller.dart';
import 'package:promoo_app/i18n/locale_controller.dart';

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
        // ServicesController watches localeProvider to refetch on language
        // change; the real LocaleController reads the device locale via
        // WidgetsBinding.instance, which isn't bound in a bare-container test.
        localeProvider.overrideWith(_FixedLocaleController.new),
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
        PromooService(
          id: 'service-1',
          title: 'Content package',
          category: ServiceCategory(id: 'cat-1', name: 'Marketing'),
        ),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        servicesRepositoryProvider.overrideWithValue(repository),
        localeProvider.overrideWith(_FixedLocaleController.new),
      ],
    );
    addTearDown(container.dispose);

    container.read(servicesControllerProvider);
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
      if (container.read(servicesControllerProvider).status !=
          ServicesStatus.loading) {
        break;
      }
    }

    await container
        .read(servicesControllerProvider.notifier)
        .selectCategory('cat-1');
    await container.read(servicesControllerProvider.notifier).search('video');

    final state = container.read(servicesControllerProvider);
    expect(state.selectedCategoryId, 'cat-1');
    expect(state.searchQuery, 'video');
    expect(repository.lastCategoryId, isNull);
    expect(repository.lastQuery, isNull);
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
        localeProvider.overrideWith(_FixedLocaleController.new),
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

  @override
  Future<Result<String>> createService(ServiceDraft draft) async =>
      const Result.success('test-service-id');

  @override
  Future<Result<void>> updateService(String id, ServiceDraft draft) async =>
      const Result.success(null);

  @override
  Future<Result<void>> deleteService(String id) async =>
      const Result.success(null);

  @override
  Future<Result<List<PromooService>>> getMyServices(String profileId) async =>
      const Result.success(<PromooService>[]);
}

class _FixedLocaleController extends LocaleController {
  @override
  Locale build() => const Locale('en');
}
