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
    expect(find.text('Listings'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Boutique influencer launch package'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Boutique influencer launch package'), findsOneWidget);
    expect(find.text('2200 AED'), findsOneWidget);
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
