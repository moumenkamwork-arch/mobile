import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
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
      color: context.colors.elevatedSurface,
      elevated: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: SizedBox(
              height: 218,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PromooImage(
                    imageUrl: highlight.imageUrl,
                    semanticLabel: highlight.title,
                    fallbackIcon: Icons.workspace_premium_rounded,
                  ),
                  // Constant dark scrim so the white title reads over the
                  // photo in both themes.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        colors: [
                          AppColors.brandBlack.withValues(alpha: 0.04),
                          AppColors.brandBlack.withValues(alpha: 0.74),
                        ],
                      ),
                    ),
                  ),
                  if (highlight.badge != null)
                    PositionedDirectional(
                      top: AppSpacing.md,
                      start: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.brandYellow,
                          borderRadius: AppRadius.pill,
                        ),
                        child: Text(
                          highlight.badge!,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.brandBlack,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    start: AppSpacing.md,
                    end: AppSpacing.md,
                    bottom: AppSpacing.md,
                    child: Text(
                      highlight.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.dark.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (highlight.subtitle != null)
                  Text(
                    highlight.subtitle!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (highlight.actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        highlight.actionLabel!,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colors.accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: context.colors.accent,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
