import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/dto/home_content_dto.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/home/presentation/screens/home_screen.dart';
import 'package:promoo_app/features/home/presentation/widgets/home_story_viewer.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_empty_state.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/shared/widgets/promoo_logo.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  const mockConfig = AppConfig();

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

    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Maya Studio'), findsOneWidget);
    expect(find.bySemanticsLabel('Promoo page logo'), findsOneWidget);
    final headerLogo = tester.widget<PromooLogo>(
      _promooLogoWithLabel('Promoo page logo'),
    );
    expect(headerLogo.height, 40);
    expect(find.text('Top Offers'), findsOneWidget);
    expect(find.text('See All'), findsAtLeastNWidgets(2));
    expect(find.byTooltip('Chats'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.text('Discover what is trending today'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('For You'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('For You'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Promoo of the Day'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Promoo of the Day'), findsOneWidget);
    expect(find.text('Boutique launch visibility pack'), findsOneWidget);
    expect(find.text('View details'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Services'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Services'), findsOneWidget);

    expect(find.text('Categories'), findsNothing);
    expect(find.text('Featured profiles'), findsNothing);
  });

  testWidgets('tapping a story opens immersive story viewer', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        _HomeRepository(Result.success(HomeContentDto.fixture().toDomain())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maya Studio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byType(HomeStoryViewer), findsOneWidget);
    expect(find.byTooltip('Close story'), findsOneWidget);
    expect(find.text('Launch day edits are ready for review.'), findsOneWidget);
    expect(find.text('Maya Studio'), findsOneWidget);

    await tester.tap(find.byTooltip('Close story'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeStoryViewer), findsNothing);
  });

  testWidgets('story viewer advances through same owner before next owner', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        _HomeRepository(Result.success(HomeContentDto.fixture().toDomain())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maya Studio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byType(HomeStoryViewer), findsOneWidget);
    expect(find.text('Maya Studio'), findsOneWidget);
    expect(find.text('Launch day edits are ready for review.'), findsOneWidget);

    final viewerSize = tester.getSize(find.byType(HomeStoryViewer));
    await tester.tapAt(
      Offset(viewerSize.width * 0.86, viewerSize.height * 0.5),
    );
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Maya Studio'), findsOneWidget);
    expect(
      find.text('Final campaign frames are being selected.'),
      findsOneWidget,
    );
    expect(find.text('Omar Visuals'), findsNothing);

    await tester.tapAt(
      Offset(viewerSize.width * 0.86, viewerSize.height * 0.5),
    );
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Premium brand visuals go live tonight.'), findsOneWidget);
    expect(find.text('Maya Studio'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Omar Visuals'), findsOneWidget);
    expect(
      find.text('Event coverage slots opened for the weekend.'),
      findsOneWidget,
    );
  });

  testWidgets('story viewer closes with a downward swipe', (tester) async {
    await tester.pumpWidget(
      _buildHomeScreen(
        _HomeRepository(Result.success(HomeContentDto.fixture().toDomain())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maya Studio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byType(HomeStoryViewer), findsOneWidget);

    await tester.fling(
      find.byType(HomeStoryViewer),
      const Offset(0, 520),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeStoryViewer), findsNothing);
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
                  title: 'Boutique launch visibility pack',
                  description:
                      'Premium visibility for curated launch partners.',
                  price: HomeContentPrice(amount: 2200, currency: 'AED'),
                ),
              ),
            ),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('View details'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();

    expect(find.text('Offer'), findsAtLeastNWidgets(1));
    expect(find.text('2200 AED'), findsOneWidget);
  });

  testWidgets('service swiper card navigates to service detail route', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.home);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(mockConfig),
          homeRepositoryProvider.overrideWithValue(
            _HomeRepository(
              Result.success(HomeContentDto.fixture().toDomain()),
            ),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Boutique influencer launch package'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Boutique influencer launch package').first);
    await tester.pumpAndSettle();

    expect(find.text('Service details'), findsOneWidget);
    expect(find.text('Boutique influencer launch package'), findsOneWidget);
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

Finder _promooLogoWithLabel(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is PromooLogo && widget.semanticLabel == label,
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
