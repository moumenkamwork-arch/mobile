import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Back arrow + single-line title row used at the top of detail-style pages
/// (profile, home content detail, service detail) that scroll their header
/// away with the rest of the content instead of pinning it.
class PromooDetailHeader extends StatelessWidget {
  const PromooDetailHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;

  /// Optional action (e.g. save/bookmark toggle) rendered at the row's end.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context).commonBack,
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ?trailing,
      ],
    );
  }
}
