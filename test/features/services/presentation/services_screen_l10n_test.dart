import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:promoo_app/features/services/domain/entities/promoo_service.dart';
import 'package:promoo_app/features/services/domain/repositories/services_repository.dart';
import 'package:promoo_app/features/services/presentation/screens/services_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'services screen renders Arabic categories and search hint, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            servicesRepositoryProvider.overrideWithValue(
              const _ServicesRepository(
                categoriesResult: Result.success([
                  ServiceCategory(id: 'cat-1', name: 'Influencer Campaigns'),
                ]),
                servicesResult: Result.success([]),
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
            home: const Scaffold(body: ServicesScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('كل الخدمات'), findsOneWidget);
      expect(find.text('ابحث عن خدمات'), findsOneWidget);
      // Arabic text, but the layout stays LTR (owner decision — no mirrored UI).
      expect(
        Directionality.of(tester.element(find.text('كل الخدمات'))),
        TextDirection.ltr,
      );

      await tester.enterText(find.byType(TextField), 'space travel');
      await tester.pumpAndSettle();

      expect(find.text('لا توجد خدمة مطابقة.'), findsOneWidget);
    },
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
