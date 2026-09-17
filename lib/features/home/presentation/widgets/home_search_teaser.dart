import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

class HomeSearchTeaser extends StatelessWidget {
  const HomeSearchTeaser({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PromooCard(
      color: colors.surface,
      onTap: () => context.push(AppRoutes.search),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Search services, seats, and profiles',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: colors.textMuted,
            size: 16,
          ),
        ],
      ),
    );
  }
}
