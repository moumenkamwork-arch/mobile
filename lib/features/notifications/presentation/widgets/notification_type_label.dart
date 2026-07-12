import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_notification.dart';

/// Resolves the localized label for a [NotificationType]. Split from the
/// domain entity because it needs `AppLocalizations`, which domain code
/// doesn't have access to.
String notificationTypeLabel(BuildContext context, NotificationType type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    NotificationType.follow => l10n.notificationTypeFollow,
    NotificationType.message => l10n.notificationTypeMessage,
    NotificationType.offer => l10n.notificationTypeOffer,
    NotificationType.system => l10n.notificationTypeSystem,
    NotificationType.payment => l10n.notificationTypePayment,
    NotificationType.unknown => l10n.notificationTypeUnknown,
  };
}
