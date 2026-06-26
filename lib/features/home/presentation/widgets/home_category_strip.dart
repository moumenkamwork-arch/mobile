import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

class HomeCategoryStrip extends StatelessWidget {
  const HomeCategoryStrip({super.key, required this.categories});

  final List<HomeCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooSectionHeader(
          title: 'Categories',
          subtitle: 'Browse popular discovery paths',
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: AppSpacing.xs);
            },
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.pill,
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
