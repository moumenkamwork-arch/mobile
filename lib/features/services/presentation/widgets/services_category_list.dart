import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_service.dart';

class ServicesCategoryList extends StatelessWidget {
  const ServicesCategoryList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<ServiceCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      ServiceCategory(
        id: '',
        name: 'All services',
        imageUrl: categories.isEmpty ? null : categories.first.imageUrl,
      ),
      ...categories,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final category = items[index];
        final isAll = index == 0;
        final selected = isAll
            ? selectedCategoryId == null
            : selectedCategoryId == category.id;

        return _CategoryCard(
          category: category,
          selected: selected,
          onTap: () => onSelected(isAll ? null : category.id),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ServiceCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = category.name;
    final colors = context.colors;

    return Semantics(
      button: true,
      selected: selected,
      label: '$label category',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: selected ? colors.elevatedSurface : colors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: selected ? colors.primaryYellow : colors.border,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.card,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PromooImage(
                    imageUrl: category.imageUrl,
                    semanticLabel: label,
                    fallbackIcon: Icons.storefront_rounded,
                  ),
                  // Constant dark scrim so the white label reads over the
                  // category photo in both themes.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        colors: [
                          AppColors.brandBlack.withValues(alpha: 0.06),
                          AppColors.brandBlack.withValues(alpha: 0.28),
                          AppColors.brandBlack.withValues(alpha: 0.82),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: AppSpacing.sm,
                    end: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.dark.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w800,
                      ),
                    ),
                  ),
                  if (selected)
                    const PositionedDirectional(
                      top: AppSpacing.sm,
                      end: AppSpacing.sm,
                      child: Icon(
                        Icons.check_circle_rounded,
                        // Over the dark scrim, brand yellow in both themes.
                        color: AppColors.brandYellow,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
