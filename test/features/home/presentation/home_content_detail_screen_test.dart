import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/home/domain/repositories/home_repository.dart';
import 'package:promoo_app/features/home/presentation/screens/home_content_detail_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildDetailScreen(_PendingHomeRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading details'), findsOneWidget);
  });

  testWidgets('renders offer detail and safe action notices', (tester) async {
    await tester.pumpWidget(
      _buildDetailScreen(
        const _HomeRepository(
          detailResult: Result.success(
            HomeContentDetail(
              id: 'offer-1',
              type: HomeContentDetailType.offer,
              title: 'Cafe opening spotlight',
              description: 'Discovery placement for a new cafe launch.',
              badge: 'Top offer',
              provider: HomeContentProvider(
                id: 'profile-pearl-cafe',
                name: 'Pearl District Cafe',
                username: 'pearl.district',
                accountType: 'company',
                isVerified: true,
              ),
              categoryName: 'Restaurants & Cafes',
              tags: ['Cafe', 'Opening'],
              price: HomeContentPrice(amount: 1500, currency: 'AED'),
              location: 'Sharjah',
              promoCode: 'PEARLSPOTLIGHT',
              validUntil: '2026-08-30',
              terms:
                  'Available for scheduled opening windows and provider-confirmed campaign dates.',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cafe opening spotlight'), findsOneWidget);
    expect(find.text('1500 AED'), findsOneWidget);
    expect(find.text('Pearl District Cafe'), findsWidgets);
    expect(find.text('Sharjah'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Contact'),
      240,
      scrollable: find.byType(Scrollable),
    );
    await tester.ensureVisible(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Open chats'), findsOneWidget);
    expect(find.text('View provider profile'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);

    await tester.tap(find.text('Contact'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.textContaining('Contact flow coming soon'), findsOneWidget);

    await tester.tap(find.text('Location'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.textContaining('Location details coming soon'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildDetailScreen(
        const _HomeRepository(
          detailResult: Result.failure(
            AppFailure.notFound(message: 'Offer not found'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load details'), findsOneWidget);
    expect(find.text('Offer not found'), findsOneWidget);
  });
}

Widget _buildDetailScreen(HomeRepository repository) {
  return ProviderScope(
    overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: HomeContentDetailScreen(type: 'offer', itemId: 'offer-1'),
      ),
    ),
  );
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

  @override
  Future<Result<void>> createStory(String mediaUrl) async {
    return const Result.success(null);
  }
}

class _PendingHomeRepository implements HomeRepository {
  const _PendingHomeRepository(this.completer);

  final Completer<Result<HomeContentDetail>> completer;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    return const Result.success(HomeContent());
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) {
    return completer.future;
  }

  @override
  Future<Result<void>> createStory(String mediaUrl) async {
    return const Result.success(null);
  }
}
