import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:promoo_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:promoo_app/features/search/domain/entities/search_result.dart';
import 'package:promoo_app/features/search/domain/repositories/search_repository.dart';
import 'package:promoo_app/features/search/presentation/screens/search_screen.dart';
import 'package:promoo_app/features/search/presentation/widgets/search_filter_chips.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_empty_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders idle state', (tester) async {
    await tester.pumpWidget(
      _buildSearchScreen(
        const _SearchRepository(result: Result.success(_successPage)),
      ),
    );

    expect(find.text('Search Promoo'), findsOneWidget);
    expect(find.byType(PromooEmptyState), findsOneWidget);
  });

  testWidgets('renders horizontally scrollable filters', (tester) async {
    await tester.pumpWidget(
      _buildSearchScreen(
        const _SearchRepository(result: Result.success(_successPage)),
      ),
    );

    expect(find.byType(SearchFilterChips), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Ads'));
    await tester.tap(find.text('Ads'));
    await tester.pumpAndSettle();

    expect(find.text('Ads'), findsOneWidget);
  });

  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildSearchScreen(_PendingSearchRepository(Completer())),
    );

    await tester.enterText(find.byType(TextField), 'studio');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pump();

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Searching Promoo'), findsOneWidget);
  });

  testWidgets('renders search results after submit', (tester) async {
    await tester.pumpWidget(
      _buildSearchScreen(
        const _SearchRepository(result: Result.success(_successPage)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'studio');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    expect(find.text('Saffron Social Studio'), findsOneWidget);
    expect(find.text('@saffron.social'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
  });

  testWidgets('profile result navigates to profile detail route', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.search);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchRepositoryProvider.overrideWithValue(
            const _SearchRepository(result: Result.success(_successPage)),
          ),
          profileRepositoryProvider.overrideWithValue(
            const _ProfileRepository(
              profileResult: Result.success(_profile),
              packagesResult: Result.success([]),
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'studio');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Saffron Social Studio'));
    await tester.pumpAndSettle();

    expect(find.text('@saffron.social'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
  });

  testWidgets('service result navigates to service detail route', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.search);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchRepositoryProvider.overrideWithValue(
            const _SearchRepository(result: Result.success(_servicePage)),
          ),
          servicesRepositoryProvider.overrideWithValue(
            const _ServicesRepository(
              detailResult: Result.success(_serviceDetail),
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'launch');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Boutique influencer launch package'));
    await tester.pumpAndSettle();

    expect(find.text('Service details'), findsOneWidget);
    expect(find.text('Boutique influencer launch package'), findsOneWidget);
  });

  testWidgets('offer result navigates to home detail route', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.search);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchRepositoryProvider.overrideWithValue(
            const _SearchRepository(result: Result.success(_offerPage)),
          ),
          homeRepositoryProvider.overrideWithValue(
            const _HomeRepository(detailResult: Result.success(_offerDetail)),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'cafe');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cafe opening spotlight'));
    await tester.pumpAndSettle();

    expect(find.text('Offer'), findsAtLeastNWidgets(1));
    expect(find.text('Cafe opening spotlight'), findsOneWidget);
    expect(find.text('1500 AED'), findsOneWidget);
  });

  testWidgets('ad result navigates to home detail route', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.search);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchRepositoryProvider.overrideWithValue(
            const _SearchRepository(result: Result.success(_adPage)),
          ),
          homeRepositoryProvider.overrideWithValue(
            const _HomeRepository(detailResult: Result.success(_adDetail)),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'spotlight');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Featured campaign spotlight'));
    await tester.pumpAndSettle();

    expect(find.text('Promotion'), findsAtLeastNWidgets(1));
    expect(find.text('Featured campaign spotlight'), findsOneWidget);
  });
}

Widget _buildSearchScreen(SearchRepository repository) {
  return ProviderScope(
    overrides: [searchRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SearchScreen()),
    ),
  );
}

const _successPage = SearchResultsPage(
  results: [
    SearchProfileResult(
      id: 'profile-saffron-social',
      title: 'Saffron Social Studio',
      username: 'saffron.social',
      isVerified: true,
    ),
  ],
);

const _servicePage = SearchResultsPage(
  results: [
    SearchServiceResult(
      id: 'service-influencer-launch',
      title: 'Boutique influencer launch package',
      description: 'Creator coverage and campaign guidance.',
      price: SearchResultPrice(amount: 2200, currency: 'AED'),
      categoryName: 'Influencer Campaigns',
    ),
  ],
);

const _offerPage = SearchResultsPage(
  results: [
    SearchOfferResult(
      id: 'offer-1',
      title: 'Cafe opening spotlight',
      description: 'Discovery placement for a new cafe launch.',
      price: SearchResultPrice(amount: 1500, currency: 'AED'),
      categoryName: 'Restaurants & Cafes',
    ),
  ],
);

const _adPage = SearchResultsPage(
  results: [
    SearchAdResult(
      id: 'ad-1',
      title: 'Featured campaign spotlight',
      description: 'Premium discovery placement for active campaigns.',
    ),
  ],
);

const _profile = PromooProfile(
  id: 'profile-saffron-social',
  displayName: 'Saffron Social Studio',
  username: 'saffron.social',
  accountType: ProfileAccountType.company,
  stats: ProfileStats(followers: 185400, services: 1),
);

const _serviceDetail = PromooService(
  id: 'service-influencer-launch',
  title: 'Boutique influencer launch package',
  description: 'Creator coverage and campaign guidance.',
  category: ServiceCategory(
    id: 'cat-influencer-campaigns',
    name: 'Influencer Campaigns',
  ),
  provider: ServiceProvider(
    id: 'profile-saffron-social',
    name: 'Saffron Social Studio',
  ),
  price: ServicePrice(amount: 2200, currency: 'AED'),
);

const _offerDetail = HomeContentDetail(
  id: 'offer-1',
  type: HomeContentDetailType.offer,
  title: 'Cafe opening spotlight',
  description: 'Discovery placement for a new cafe launch.',
  price: HomeContentPrice(amount: 1500, currency: 'AED'),
);

const _adDetail = HomeContentDetail(
  id: 'ad-1',
  type: HomeContentDetailType.ad,
  title: 'Featured campaign spotlight',
  description: 'Premium discovery placement for active campaigns.',
);

class _SearchRepository implements SearchRepository {
  const _SearchRepository({required this.result});

  final Result<SearchResultsPage> result;

  @override
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter = SearchFilterType.all,
    int page = 1,
    int limit = 20,
  }) async {
    return result;
  }
}

class _PendingSearchRepository implements SearchRepository {
  const _PendingSearchRepository(this.completer);

  final Completer<Result<SearchResultsPage>> completer;

  @override
  Future<Result<SearchResultsPage>> search({
    required String query,
    SearchFilterType filter = SearchFilterType.all,
    int page = 1,
    int limit = 20,
  }) {
    return completer.future;
  }
}

class _ProfileRepository implements ProfileRepository {
  const _ProfileRepository({
    required this.profileResult,
    required this.packagesResult,
  });

  final Result<PromooProfile> profileResult;
  final Result<List<ProfilePackage>> packagesResult;

  @override
  Future<Result<PromooProfile>> getDemoProfile() async {
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getProfile(String idOrUsername) async {
    return profileResult;
  }

  @override
  Future<Result<PromooProfile>> getMyProfile() async {
    return profileResult;
  }

  @override
  Future<Result<List<ProfilePackage>>> getProfilePackages(
    String profileId,
  ) async {
    return packagesResult;
  }

  @override
  Future<Result<PromooProfile>> updateMyProfile(
    ProfileUpdateDraft draft,
  ) async {
    return const Result.failure(
      AppFailure.unauthorized(message: 'Sign in to edit your profile.'),
    );
  }
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
