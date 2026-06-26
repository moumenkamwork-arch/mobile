import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

class ProfileMediaSection extends StatelessWidget {
  const ProfileMediaSection({super.key, required this.mediaUrls});

  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PromooSectionHeader(
          title: 'Media',
          subtitle: 'Recent profile posts and campaign visuals',
        ),
        const SizedBox(height: AppSpacing.md),
        if (mediaUrls.isEmpty)
          const PromooEmptyState(
            title: 'No media yet',
            message: 'Profile media will appear here when it is available.',
            icon: Icons.photo_library_outlined,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaUrls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
            ),
            itemBuilder: (context, index) {
              return _ProfileMediaTile(
                index: index,
                mediaUrl: mediaUrls[index],
              );
            },
          ),
      ],
    );
  }
}

class _ProfileMediaTile extends StatelessWidget {
  const _ProfileMediaTile({required this.index, required this.mediaUrl});

  final int index;
  final String mediaUrl;

  @override
  Widget build(BuildContext context) {
    final isVideo =
        mediaUrl.toLowerCase().contains('video') ||
        mediaUrl.toLowerCase().contains('reel') ||
        mediaUrl.toLowerCase().endsWith('.mp4');

    return Semantics(
      image: true,
      label: 'Profile media item ${index + 1}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: index == 0 ? AppColors.primaryYellow : AppColors.border,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.card,
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      AppColors.elevatedSurface,
                      index.isEven ? AppColors.surface : AppColors.cardSurface,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(
                isVideo
                    ? Icons.play_circle_outline_rounded
                    : Icons.image_outlined,
                color: AppColors.primaryYellow,
                size: 26,
              ),
            ),
            PositionedDirectional(
              start: AppSpacing.xs,
              bottom: AppSpacing.xs,
              child: Text(
                'Post ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
