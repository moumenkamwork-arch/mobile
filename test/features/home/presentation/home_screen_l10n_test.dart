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
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'home screen renders Arabic section titles and badges, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _HomeRepository(
                Result.success(HomeContentDto.fixture().toDomain()),
              ),
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
            home: const Scaffold(body: HomeScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('القصص'), findsOneWidget);
      expect(find.text('أفضل العروض'), findsOneWidget);
      expect(find.text('عرض الكل'), findsAtLeastNWidgets(2));
      expect(find.text('أفضل عرض'), findsWidgets);
      expect(find.byTooltip('المحادثات'), findsOneWidget);
      expect(find.byTooltip('التنبيهات'), findsOneWidget);
      // Arabic text, but the layout stays LTR (owner decision — no mirrored UI).
      expect(
        Directionality.of(tester.element(find.text('القصص'))),
        TextDirection.ltr,
      );
    },
  );
}

class _HomeRepository implements HomeRepository {
  const _HomeRepository(this.result);

  final Result<HomeContent> result;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    return result;
  }

  @override
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return const Result.failure(
      AppFailure.notFound(message: 'Home item not found.'),
    );
  }

  @override
  Future<Result<void>> createStory(String mediaUrl) async {
    return const Result.success(null);
  }
}
