import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/seats/data/repositories/seats_repository_impl.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';
import 'package:promoo_app/features/seats/domain/repositories/seats_repository.dart';
import 'package:promoo_app/features/seats/presentation/screens/seats_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'seats screen renders Arabic tier legend (noun-first grammar), stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            seatsRepositoryProvider.overrideWithValue(
              const _SeatsRepository(seatsResult: Result.success([])),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Mirrors lib/app.dart: translate, don't mirror the layout.
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const Scaffold(body: SeatsScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Arabic adjective+noun order is noun-first ("مقاعد ذهبية" = "seats
      // gold"), unlike English's "Gold Seats" — this proves the ICU `select`
      // phrases (not naive concatenation) are wired correctly.
      expect(find.text('مقاعد ذهبية'), findsOneWidget);
      expect(find.text('مقاعد فضية'), findsOneWidget);
      expect(find.text('مقاعد برونزية'), findsOneWidget);
      expect(find.text('المؤثرون'), findsOneWidget);
      expect(find.text('المقاعد المتاحة'), findsOneWidget);
      // Arabic text, but the layout stays LTR (owner decision — no mirrored UI).
      expect(
        Directionality.of(tester.element(find.text('مقاعد ذهبية'))),
        TextDirection.ltr,
      );
    },
  );

  testWidgets('occupied seat sheet shows Arabic singular tier label', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          seatsRepositoryProvider.overrideWithValue(
            const _SeatsRepository(seatsResult: Result.success(_occupiedSeat)),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Mirrors lib/app.dart: translate, don't mirror the layout.
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const Scaffold(body: SeatsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lina Atelier'));
    await tester.pumpAndSettle();

    // "Silver Seat" (singular) → "مقعد فضي" (noun-first, not "فضي مقعد").
    expect(find.text('مقعد فضي'), findsOneWidget);
  });
}

const _occupiedSeat = [
  Seat(
    id: 'seat-occupied',
    tier: SeatTier.silver,
    status: SeatStatus.booked,
    position: 1,
    price: SeatPrice(amount: 1500, currency: 'AED'),
    holder: SeatHolder(id: 'profile-lina-atelier', name: 'Lina Atelier'),
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
