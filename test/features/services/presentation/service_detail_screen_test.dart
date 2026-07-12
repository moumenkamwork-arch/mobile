import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/screens/service_detail_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildServiceDetailScreen(_PendingServicesRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading service details'), findsOneWidget);
  });

  testWidgets('renders service details and contact notice', (tester) async {
    await tester.pumpWidget(
      _buildServiceDetailScreen(
        const _ServicesRepository(
          detailResult: Result.success(
            PromooService(
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
                username: 'saffron.social',
                accountType: 'company',
                isVerified: true,
              ),
              price: ServicePrice(amount: 2200, currency: 'AED'),
              location: 'Dubai',
              deliveryDays: 5,
              tags: ['Campaign', 'Reels', 'Stories'],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Boutique influencer launch package'), findsWidgets);
    expect(find.text('2200 AED'), findsOneWidget);
    expect(find.text('Influencer Campaigns'), findsOneWidget);
    expect(find.text('Saffron Social Studio'), findsWidgets);
    expect(find.text('Dubai'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Contact provider'),
      240,
      scrollable: find.byType(Scrollable),
    );
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Contact provider'),
    );
    await tester.drag(find.byType(Scrollable), const Offset(0, -160));
    await tester.pumpAndSettle();
    expect(find.text('Contact provider'), findsOneWidget);
    expect(find.text('Open chats'), findsOneWidget);
    expect(find.text('View provider profile'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Contact provider'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Contact flow coming soon'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildServiceDetailScreen(
        const _ServicesRepository(
          detailResult: Result.failure(
            AppFailure.notFound(message: 'Service not found'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Could not load service'), findsOneWidget);
    expect(find.text('Service not found'), findsOneWidget);
  });
}

Widget _buildServiceDetailScreen(ServicesRepository repository) {
  return ProviderScope(
    overrides: [servicesRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: ServiceDetailScreen(serviceId: 'service-influencer-launch'),
      ),
    ),
  );
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

class _PendingServicesRepository implements ServicesRepository {
  const _PendingServicesRepository(this.completer);

  final Completer<Result<PromooService>> completer;

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
  Future<Result<PromooService>> getServiceById(String id) {
    return completer.future;
  }
}
