import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Small pill-shaped label used on detail pages (category, provider,
/// location, tags...). [highlighted] renders a filled brand-yellow chip
/// (e.g. an offer/ad type badge) instead of the plain outlined style.
class PromooDetailChip extends StatelessWidget {
  const PromooDetailChip({
    super.key,
    required this.label,
    this.icon,
    this.highlighted = false,
  });

  final String label;
  final IconData? icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = highlighted ? AppColors.brandBlack : colors.textPrimary;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: highlighted ? colors.primaryYellow : colors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: highlighted ? colors.primaryYellow : colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: highlighted ? AppColors.brandBlack : colors.accent,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: highlighted ? FontWeight.w800 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
