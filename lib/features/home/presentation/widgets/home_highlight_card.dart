import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

class HomeHighlightCard extends StatelessWidget {
  const HomeHighlightCard({super.key, required this.highlight, this.onTap});

  final HomeHighlight highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      onTap: onTap,
      color: AppColors.elevatedSurface,
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlight.badge != null)
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                highlight.badge!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.brandBlack,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            highlight.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (highlight.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              highlight.subtitle!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (highlight.actionLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  highlight.actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryYellow,
                  size: 18,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
