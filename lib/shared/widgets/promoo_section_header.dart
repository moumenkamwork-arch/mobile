import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class PromooSectionHeader extends StatelessWidget {
  const PromooSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onActionPressed != null) ...[
          const SizedBox(width: AppSpacing.md),
          TextButton(onPressed: onActionPressed, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}
