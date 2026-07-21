import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/home/presentation/controllers/home_controller.dart';
import 'package:promoo_app/i18n/locale_controller.dart';

void main() {
  test('emits loading then success', () async {
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          _HomeRepository(Result.success(HomeContentDto.fixture().toDomain())),
        ),
        // HomeController watches localeProvider to refetch on language change;
        // the real LocaleController reads the device locale via
        // WidgetsBinding.instance, which isn't bound in a bare-container test.
        localeProvider.overrideWith(_FixedLocaleController.new),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(homeControllerProvider).status, HomeStatus.loading);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeControllerProvider);
    expect(state.status, HomeStatus.success);
    expect(state.content?.categories, isNotEmpty);
  });

  test('emits error when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          const _HomeRepository(
            Result.failure(AppFailure.network(message: 'No connection')),
          ),
        ),
        localeProvider.overrideWith(_FixedLocaleController.new),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(homeControllerProvider).status, HomeStatus.loading);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeControllerProvider);
    expect(state.status, HomeStatus.error);
    expect(state.failure?.message, 'No connection');
  });
}

class _HomeRepository implements HomeRepository {
  const _HomeRepository(this.result);

  final Result<HomeContent> result;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    return result;
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return const Result.failure(
      AppFailure.notFound(message: 'Home item not found.'),
    );
  }
}

class _FixedLocaleController extends LocaleController {
  @override
  Locale build() => const Locale('en');
}
