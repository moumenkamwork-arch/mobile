import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/chat.dart';

/// Resolves the localized label for a [ChatMessageStatus]. Split from the
/// domain entity because it needs `AppLocalizations`, which domain code
/// doesn't have access to.
String chatMessageStatusLabel(BuildContext context, ChatMessageStatus status) {
  final l10n = AppLocalizations.of(context);
  return switch (status) {
    ChatMessageStatus.sending => l10n.chatMessageStatusSending,
    ChatMessageStatus.sent => l10n.chatMessageStatusSent,
    ChatMessageStatus.delivered => l10n.chatMessageStatusDelivered,
    ChatMessageStatus.read => l10n.chatMessageStatusRead,
    ChatMessageStatus.failed => l10n.chatMessageStatusFailed,
    ChatMessageStatus.unknown => l10n.chatMessageStatusUnknown,
  };
}
