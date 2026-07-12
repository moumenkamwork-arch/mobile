import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:promoo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:promoo_app/features/auth/presentation/screens/register_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets('login screen renders Arabic + RTL and validates in Arabic', (
    tester,
  ) async {
    await tester.pumpWidget(_arabicAuthApp(const LoginScreen()));

    expect(find.text('البريد الإلكتروني'), findsWidgets);
    expect(find.text('كلمة المرور'), findsWidgets);
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('المتابعة كضيف'), findsOneWidget);
    // Arabic text, but the layout stays LTR (owner decision — no mirrored UI).
    expect(
      Directionality.of(tester.element(find.text('المتابعة كضيف'))),
      TextDirection.ltr,
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.text('البريد الإلكتروني مطلوب.'), findsOneWidget);
  });

  testWidgets('register screen renders Arabic account type labels', (
    tester,
  ) async {
    await tester.pumpWidget(_arabicAuthApp(const RegisterScreen()));

    expect(find.text('إنشاء الحساب'), findsWidgets);
    expect(find.text('نوع الحساب'), findsOneWidget);
    expect(find.text('شركة'), findsOneWidget);
    expect(find.text('مؤثر'), findsOneWidget);
  });
}

Widget _arabicAuthApp(Widget screen) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(const _AuthRepository()),
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
      home: screen,
    ),
  );
}

class _AuthRepository implements AuthRepository {
  const _AuthRepository();

  @override
  Future<Result<AuthSession?>> getStoredSession() async {
    return const Result.success(null);
  }

  @override
  Future<Result<AuthSession>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<AuthSession>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    required AuthAccountType accountType,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<AuthSession>> refreshSession() async {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() async {
    return const Result.success(null);
  }
}
