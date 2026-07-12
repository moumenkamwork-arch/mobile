import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';
import 'package:promoo_app/features/seats/domain/repositories/seats_repository.dart';
import 'package:promoo_app/features/seats/presentation/screens/seats_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/routing/app_router.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shared/widgets/promoo_error_state.dart';
import 'package:promoo_app/shared/widgets/promoo_loading_indicator.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      _buildSeatsScreen(_PendingSeatsRepository(Completer())),
    );

    expect(find.byType(PromooLoadingIndicator), findsOneWidget);
    expect(find.text('Loading seats'), findsOneWidget);
  });

  testWidgets('renders search, tier legend, and the seat grid', (tester) async {
    await tester.pumpWidget(
      _buildSeatsScreen(
        const _SeatsRepository(seatsResult: Result.success(_interactiveSeats)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Gold Seats'), findsOneWidget);
    expect(find.text('Silver Seats'), findsOneWidget);
    expect(find.text('Bronze Seats'), findsOneWidget);
    expect(find.text('Book Seat'), findsWidgets);
    expect(find.text('Lina Atelier'), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    await tester.pumpWidget(
      _buildSeatsScreen(
        const _SeatsRepository(
          seatsResult: Result.failure(
            AppFailure.network(message: 'No connection'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PromooErrorState), findsOneWidget);
    expect(find.text('Seats unavailable'), findsOneWidget);
    expect(find.text('No connection'), findsOneWidget);
  });

  testWidgets('occupied influencer seat opens profile preview sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSeatsApp(
        const _SeatsRepository(seatsResult: Result.success(_interactiveSeats)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lina Atelier'));
    await tester.pumpAndSettle();

    expect(find.text('Lina Atelier'), findsWidgets);
    expect(find.text('Silver Seat'), findsOneWidget);
    expect(find.text('View profile'), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);
  });

  testWidgets('available seat opens tier sheet and checkout preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSeatsApp(
        const _SeatsRepository(seatsResult: Result.success(_interactiveSeats)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book Seat').first);
    await tester.pumpAndSettle();

    expect(find.text('Gold Seat'), findsOneWidget);
    expect(find.text('Book Now'), findsOneWidget);
    expect(find.textContaining('Gold seats provide'), findsOneWidget);

    await tester.tap(find.text('Book Now'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout preview'), findsOneWidget);
    expect(find.text('2500 AED'), findsOneWidget);
  });
}

Widget _buildSeatsScreen(SeatsRepository repository) {
  return ProviderScope(
    overrides: [seatsRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SeatsScreen()),
    ),
  );
}

Widget _buildSeatsApp(SeatsRepository repository) {
  final router = createAppRouter(initialLocation: AppRoutes.seats);
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(_mockConfig),
      seatsRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

const _mockConfig = AppConfig();

const _interactiveSeats = [
  Seat(
    id: 'seat-open',
    tier: SeatTier.gold,
    status: SeatStatus.available,
    position: 1,
    price: SeatPrice(amount: 2500, currency: 'AED'),
  ),
  Seat(
    id: 'seat-occupied',
    tier: SeatTier.silver,
    status: SeatStatus.booked,
    position: 1,
    price: SeatPrice(amount: 1500, currency: 'AED'),
    holder: SeatHolder(
      id: 'profile-lina-atelier',
      name: 'Lina Atelier',
      username: 'lina.atelier',
    ),
  ),
];

class _SeatsRepository implements SeatsRepository {
  const _SeatsRepository({required this.seatsResult});

  final Result<List<Seat>> seatsResult;

  @override
  Future<Result<List<Seat>>> getSeats({SeatTier? tier}) async {
    return seatsResult;
  }

  @override
  Future<Result<List<Seat>>> getMySeats() async {
    return const Result.success([]);
  }

  @override
  Future<Result<SeatBookingResult>> bookSeat(String seatId) async {
    return const Result.success(SeatBookingResult(status: SeatStatus.pending));
  }
}

class _PendingSeatsRepository implements SeatsRepository {
  const _PendingSeatsRepository(this.completer);

  final Completer<Result<List<Seat>>> completer;

  @override
  Future<Result<List<Seat>>> getSeats({SeatTier? tier}) {
    return completer.future;
  }

  @override
  Future<Result<List<Seat>>> getMySeats() {
    return Future.value(const Result.success([]));
  }

  @override
  Future<Result<SeatBookingResult>> bookSeat(String seatId) {
    return Future.value(
      const Result.success(SeatBookingResult(status: SeatStatus.pending)),
    );
  }
}
