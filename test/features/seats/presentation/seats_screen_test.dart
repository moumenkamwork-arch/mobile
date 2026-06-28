import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/errors/app_failure.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';
import 'package:promoo_app/features/seats/domain/repositories/seats_repository.dart';
import 'package:promoo_app/features/seats/presentation/screens/seats_screen.dart';
import 'package:promoo_app/features/seats/presentation/widgets/seat_tier_cards.dart';
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

  testWidgets('renders seats content and login-required booking behavior', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSeatsScreen(
        const _SeatsRepository(
          seatsResult: Result.success([
            Seat(
              id: 'seat-1',
              tier: SeatTier.gold,
              status: SeatStatus.available,
              position: 1,
              price: SeatPrice(amount: 2500, currency: 'AED'),
            ),
            Seat(
              id: 'seat-2',
              tier: SeatTier.silver,
              status: SeatStatus.booked,
              position: 2,
              price: SeatPrice(amount: 1500, currency: 'AED'),
            ),
          ]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Influencer Seats'), findsOneWidget);
    expect(find.text('Gold visibility'), findsOneWidget);
    expect(find.text('Silver placement'), findsOneWidget);
    expect(find.text('Bronze visibility'), findsOneWidget);
    expect(find.text('Influencer visibility grid'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byType(SeatTierCards),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(SeatTierCards), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Gold Seat 1'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Gold Seat 1'), findsOneWidget);
    expect(find.text('2500 AED'), findsOneWidget);
    expect(find.text('Login required'), findsOneWidget);

    await tester.tap(find.text('Login required'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Go to login'),
      -260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Login required'), findsAtLeastNWidgets(1));
    expect(
      find.text('Sign in to continue when booking opens.'),
      findsOneWidget,
    );
    expect(find.text('Go to login'), findsOneWidget);
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
    expect(find.text('Could not load seats'), findsOneWidget);
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

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('seat-grid-slot-seat-occupied')),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('seat-grid-slot-seat-occupied')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('seat-preview-sheet')), findsOneWidget);
    expect(find.text('Lina Atelier'), findsWidgets);
    expect(find.text('View profile'), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);
  });

  testWidgets('available influencer seat opens checkout preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSeatsApp(
        const _SeatsRepository(seatsResult: Result.success(_interactiveSeats)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('seat-grid-slot-seat-open')),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('seat-grid-slot-seat-open')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('seat-preview-sheet')), findsOneWidget);
    expect(find.text('Book Now'), findsOneWidget);

    await tester.tap(find.text('Book Now'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout preview'), findsOneWidget);
    expect(find.text('Preview payment'), findsOneWidget);
    expect(find.text('2500 AED'), findsOneWidget);
  });
}

Widget _buildSeatsScreen(SeatsRepository repository) {
  return ProviderScope(
    overrides: [seatsRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.dark,
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
    child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
  );
}

const _mockConfig = AppConfig(
  environment: AppEnvironment.development,
  baseUrl: 'https://api.promoo.example/api/v1',
  useMocks: true,
);

const _interactiveSeats = [
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
  Seat(
    id: 'seat-open',
    tier: SeatTier.gold,
    status: SeatStatus.available,
    position: 2,
    price: SeatPrice(amount: 2500, currency: 'AED'),
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
