import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PromooLogo.compact(width: 36, height: 36),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Promoo', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                'Discover what is trending today',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ),
      ],
    );
  }
}
