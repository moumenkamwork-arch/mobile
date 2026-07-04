import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/screens/services_screen.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildServicesScreen(_PendingServicesRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading services'), findsOneWidget);
  });

  testWidgets('renders services list', (tester) async {
    await tester.pumpWidget(
      _buildServicesScreen(
        const _ServicesRepository(
          categoriesResult: Result.success([
            ServiceCategory(id: 'cat-1', name: 'Influencer Campaigns'),
          ]),
          servicesResult: Result.success([
            PromooService(
              id: 'service-1',
              title: 'Boutique influencer launch package',
              description: 'Creator coverage and campaign guidance.',
              category: ServiceCategory(
                id: 'cat-1',
                name: 'Influencer Campaigns',
              ),
              price: ServicePrice(amount: 2200, currency: 'AED'),
            ),
          ]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Service categories'), findsOneWidget);
    expect(find.text('All services'), findsOneWidget);
    expect(find.text('Influencer Campaigns'), findsWidgets);
    expect(find.text('Search other services'), findsOneWidget);
    expect(find.text('Listings'), findsNothing);

    await tester.tap(find.text('Influencer Campaigns').first);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Boutique influencer launch package'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Boutique influencer launch package'), findsOneWidget);
    expect(find.text('2200 AED'), findsOneWidget);
  });

  testWidgets(
    'live search shows matching service results without another load',
    (tester) async {
      final repository = _CountingSearchableServicesRepository(
        categories: const [
          ServiceCategory(id: 'cat-1', name: 'Influencer Campaigns'),
        ],
        services: const [
          PromooService(
            id: 'service-1',
            title: 'Boutique influencer launch package',
            description: 'Creator coverage and campaign guidance.',
            category: ServiceCategory(
              id: 'cat-1',
              name: 'Influencer Campaigns',
            ),
            provider: ServiceProvider(
              id: 'provider-1',
              name: 'Saffron Social Studio',
            ),
            tags: ['Campaign'],
          ),
        ],
      );

      await tester.pumpWidget(_buildServicesScreen(repository));
      await tester.pumpAndSettle();

      expect(repository.servicesCallCount, 1);

      await tester.enterText(find.byType(TextField), 'saffron');
      await tester.pumpAndSettle();

      expect(find.text('Boutique influencer launch package'), findsOneWidget);
      expect(repository.servicesCallCount, 1);
    },
  );

  testWidgets('search shows a clear empty message when no service matches', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildServicesScreen(
        const _SearchableServicesRepository(
          categories: [ServiceCategory(id: 'cat-1', name: 'Beauty')],
          services: [
            PromooService(id: 'service-1', title: 'Salon launch promotion'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'space travel');
    await tester.pumpAndSettle();

    expect(find.text('No service found.'), findsOneWidget);
    expect(find.text("We couldn't find this service yet."), findsOneWidget);
  });

  testWidgets('clearing live search restores hidden default result state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildServicesScreen(
        const _SearchableServicesRepository(
          categories: [ServiceCategory(id: 'cat-1', name: 'Beauty')],
          services: [
            PromooService(id: 'service-1', title: 'Salon launch promotion'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'salon');
    await tester.pumpAndSettle();
    expect(find.text('Salon launch promotion'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('Salon launch promotion'), findsNothing);
  });

  testWidgets('service card navigates to service detail route', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.services);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          servicesRepositoryProvider.overrideWithValue(
            const _ServicesRepository(
              categoriesResult: Result.success([
                ServiceCategory(id: 'cat-1', name: 'Influencer Campaigns'),
              ]),
              servicesResult: Result.success([
                PromooService(
                  id: 'service-influencer-launch',
                  title: 'Boutique influencer launch package',
                  description: 'Creator coverage and campaign guidance.',
                  category: ServiceCategory(
                    id: 'cat-1',
                    name: 'Influencer Campaigns',
                  ),
                  price: ServicePrice(amount: 2200, currency: 'AED'),
                ),
              ]),
            ),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Influencer Campaigns').first);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Boutique influencer launch package'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Boutique influencer launch package'));
    await tester.pumpAndSettle();

    expect(find.text('Service details'), findsOneWidget);
    expect(find.text('Service detail'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildServicesScreen(
        const _ServicesRepository(
          categoriesResult: Result.failure(
            AppFailure.network(message: 'No connection'),
          ),
          servicesResult: Result.success([]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load services'), findsOneWidget);
    expect(find.text('No connection'), findsOneWidget);
  });
}

Widget _buildServicesScreen(ServicesRepository repository) {
  return ProviderScope(
    overrides: [servicesRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const Scaffold(body: ServicesScreen()),
    ),
  );
}

class _ServicesRepository implements ServicesRepository {
  const _ServicesRepository({
    required this.categoriesResult,
    required this.servicesResult,
  });

  final Result<List<ServiceCategory>> categoriesResult;
  final Result<List<PromooService>> servicesResult;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    return categoriesResult;
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) async {
    return servicesResult;
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    return const Result.success(
      PromooService(id: 'service-detail', title: 'Service detail'),
    );
  }
}

class _SearchableServicesRepository implements ServicesRepository {
  const _SearchableServicesRepository({
    required this.categories,
    required this.services,
  });

  final List<ServiceCategory> categories;
  final List<PromooService> services;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    return Result.success(categories);
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase() ?? '';
    final results = services
        .where((service) {
          final matchesCategory =
              categoryId == null || service.category?.id == categoryId;
          final searchable = [
            service.title,
            service.description,
            service.category?.name,
            service.provider?.name,
            ...service.tags,
          ].whereType<String>().join(' ').toLowerCase();
          final matchesQuery =
              normalizedQuery.isEmpty || searchable.contains(normalizedQuery);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);

    return Result.success(results);
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    return Result.success(services.first);
  }
}

class _CountingSearchableServicesRepository
    extends _SearchableServicesRepository {
  _CountingSearchableServicesRepository({
    required super.categories,
    required super.services,
  });

  var servicesCallCount = 0;

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) {
    servicesCallCount += 1;
    return super.getServices(categoryId: categoryId, query: query);
  }
}

class _PendingServicesRepository implements ServicesRepository {
  const _PendingServicesRepository(this.completer);

  final Completer<Result<List<ServiceCategory>>> completer;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() {
    return completer.future;
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) {
    return Future.value(const Result.success([]));
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) {
    return Future.value(
      const Result.success(
        PromooService(id: 'service-detail', title: 'Service detail'),
      ),
    );
  }
}
