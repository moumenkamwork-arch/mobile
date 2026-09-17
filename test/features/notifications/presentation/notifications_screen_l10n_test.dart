import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/utils/result.dart';
import 'package:promoo_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:promoo_app/features/notifications/domain/entities/app_notification.dart';
import 'package:promoo_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:promoo_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:promoo_app/theme/app_theme.dart';

void main() {
  testWidgets(
    'notifications screen renders Arabic header, count, and type label, stays LTR',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationsRepositoryProvider.overrideWithValue(
              _NotificationsRepository(notifications: [_notification]),
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
            home: const Scaffold(body: NotificationsScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التنبيهات'), findsOneWidget);
      // Real Arabic plural grammar for a single unread notification.
      expect(find.text('إشعار واحد غير مقروء'), findsOneWidget);
      expect(find.text('تحديد الكل كمقروء'), findsOneWidget);
      // Notification type label reuses the same word as chat's "Message".
      expect(find.text('رسالة'), findsOneWidget);

      expect(
        Directionality.of(tester.element(find.text('التنبيهات'))),
        TextDirection.ltr,
      );
    },
  );
}

final _notification = AppNotification(
  id: 'notification-1',
  title: 'New message',
  body: 'Saffron Social Studio sent a campaign update.',
  type: NotificationType.message,
  createdAt: DateTime(2026, 6, 26, 9, 22),
);

class _NotificationsRepository implements NotificationsRepository {
  const _NotificationsRepository({this.notifications = const []});

  final List<AppNotification> notifications;

  @override
  Future<Result<void>> deleteNotification(String id) async {
    return const Result.success(null);
  }

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    return Result.success(notifications);
  }

  @override
  Future<Result<void>> markAllRead() async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> markRead(String id) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> registerDeviceToken({
    required String token,
    String? deviceType,
  }) async {
    return const Result.success(null);
  }
}
