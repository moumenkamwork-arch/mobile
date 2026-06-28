import 'package:flutter/material.dart';

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
      const ServiceCategory(id: '', name: 'All services'),
      ...categories,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final category = items[index];
        final isAll = index == 0;
        final selected = isAll
            ? selectedCategoryId == null
            : selectedCategoryId == category.id;

        return _CategoryCard(
          label: category.name,
          selected: selected,
          icon: _iconForCategory(category.name),
          onTap: () => onSelected(isAll ? null : category.id),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: selected ? AppColors.elevatedSurface : AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: selected ? AppColors.primaryYellow : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryYellow
                        : AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryYellow
                          : AppColors.borderStrong,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: selected
                        ? AppColors.brandBlack
                        : AppColors.primaryYellow,
                    size: 20,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData _iconForCategory(String label) {
  final normalized = label.toLowerCase();
  if (normalized.contains('influencer') ||
      normalized.contains('creator') ||
      normalized.contains('content')) {
    return Icons.auto_awesome_rounded;
  }
  if (normalized.contains('ad') || normalized.contains('marketing')) {
    return Icons.campaign_rounded;
  }
  if (normalized.contains('design') || normalized.contains('brand')) {
    return Icons.brush_rounded;
  }
  if (normalized.contains('business') || normalized.contains('growth')) {
    return Icons.trending_up_rounded;
  }
  return Icons.storefront_rounded;
}
