import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/home/presentation/screens/home_screen.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_empty_state.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        _PendingHomeRepository(Completer<Result<HomeContent>>()),
      ),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading Promoo home'), findsOneWidget);
  });

  testWidgets('renders success state', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        _HomeRepository(Result.success(HomeContentDto.fixture().toDomain())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Promoo of the day'), findsOneWidget);
    expect(find.text('View details'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Services'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Services'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Featured profiles'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Featured profiles'), findsOneWidget);
  });

  testWidgets('highlight card navigates to home detail route', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.home);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _HomeRepository(
              Result.success(HomeContentDto.fixture().toDomain()),
              detailResult: const Result.success(
                HomeContentDetail(
                  id: 'offer-featured',
                  type: HomeContentDetailType.offer,
                  title: 'Promoo of the day',
                  description: 'Premium visibility for demo partners.',
                  price: HomeContentPrice(amount: 1200, currency: 'AED'),
                ),
              ),
            ),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();

    expect(find.text('Offer'), findsAtLeastNWidgets(1));
    expect(find.text('1200 AED'), findsOneWidget);
  });

  testWidgets('renders empty state', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(const _HomeRepository(Result.success(HomeContent()))),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooEmptyState), findsOneWidget);
    expect(find.text('Nothing to show yet'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        const _HomeRepository(
          Result.failure(AppFailure.network(message: 'No connection')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load home'), findsOneWidget);
    expect(find.text('No connection'), findsOneWidget);
  });
}

Widget _buildHomeScreen(HomeRepository repository) {
  return ProviderScope(
    overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const Scaffold(body: HomeScreen()),
    ),
  );
}

class _HomeRepository implements HomeRepository {
  const _HomeRepository(
    this.result, {
    this.detailResult = const Result.failure(
      AppFailure.notFound(message: 'Home item not found.'),
    ),
  });

  final Result<HomeContent> result;
  final Result<HomeContentDetail> detailResult;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    return result;
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return detailResult;
  }
}

class _PendingHomeRepository implements HomeRepository {
  const _PendingHomeRepository(this.completer);

  final Completer<Result<HomeContent>> completer;

  @override
  Future<Result<HomeContent>> getHomeContent() {
    return completer.future;
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) {
    return Future.value(
      const Result.failure(
        AppFailure.notFound(message: 'Home item not found.'),
      ),
    );
  }
}
