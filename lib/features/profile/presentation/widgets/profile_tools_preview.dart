import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

class ProfileToolsPreview extends StatelessWidget {
  const ProfileToolsPreview({super.key, required this.onToolPressed});

  final ValueChanged<String> onToolPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PromooSectionHeader(
          title: 'Profile tools',
          subtitle: 'Manage your presence and creator actions',
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          childAspectRatio: 1.75,
          children: [
            for (final tool in _profileTools)
              _ProfileToolTile(
                tool: tool,
                onTap: () => onToolPressed(tool.label),
              ),
          ],
        ),
      ],
    );
  }
}

const _profileTools = [
  _ProfileTool(
    label: 'Manage profile',
    description: 'Profile details',
    icon: Icons.manage_accounts_rounded,
  ),
  _ProfileTool(
    label: 'Create offers',
    description: 'Add new offer',
    icon: Icons.add_box_rounded,
  ),
  _ProfileTool(
    label: 'Saved items',
    description: 'Saved content',
    icon: Icons.bookmark_rounded,
  ),
  _ProfileTool(
    label: 'Support',
    description: 'Help center',
    icon: Icons.support_agent_rounded,
  ),
  _ProfileTool(
    label: 'Language',
    description: 'Arabic / English',
    icon: Icons.language_rounded,
  ),
];

class _ProfileTool {
  const _ProfileTool({
    required this.label,
    required this.description,
    required this.icon,
  });

  final String label;
  final String description;
  final IconData icon;
}

class _ProfileToolTile extends StatelessWidget {
  const _ProfileToolTile({required this.tool, required this.onTap});

  final _ProfileTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tool.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Ink(
            padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderStrong),
                  ),
                  child: Icon(
                    tool.icon,
                    color: AppColors.primaryYellow,
                    size: 19,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.xxxs),
                      Text(
                        tool.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
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
