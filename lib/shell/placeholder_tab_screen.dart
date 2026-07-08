import 'package:flutter/material.dart';

import '../shared/widgets/promoo_card.dart';
import '../shared/widgets/promoo_section_header.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PlaceholderTabScreen extends StatelessWidget {
  const PlaceholderTabScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.screenVertical,
        AppSpacing.screenHorizontal,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromooSectionHeader(title: title, subtitle: 'Placeholder only'),
          const SizedBox(height: AppSpacing.lg),
          PromooCard(
            elevated: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.elevatedSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Icon(icon, color: context.colors.accent),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No feature data, repositories, or API calls are wired in this step.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
