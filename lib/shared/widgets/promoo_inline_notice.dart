import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'promoo_card.dart';

/// Dismissible info card (icon + message + close button) used to surface
/// safe "coming soon" notices on detail/action pages.
class PromooInlineNotice extends StatelessWidget {
  const PromooInlineNotice({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      borderColor: context.colors.accent,
      color: context.colors.elevatedSurface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: context.colors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).commonDismiss,
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}
