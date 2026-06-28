import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import 'profile_media_viewer.dart';

class ProfileMediaSection extends StatelessWidget {
  const ProfileMediaSection({
    super.key,
    required this.mediaUrls,
    required this.profileName,
    this.avatarUrl,
  });

  final List<String> mediaUrls;
  final String profileName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final mediaItems = _mediaItemsFrom(mediaUrls);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PromooSectionHeader(
          title: 'Media',
          subtitle: 'Recent profile posts and campaign visuals',
        ),
        const SizedBox(height: AppSpacing.md),
        if (mediaItems.isEmpty)
          const PromooEmptyState(
            title: 'No media yet',
            message: 'Profile media will appear here when it is available.',
            icon: Icons.photo_library_outlined,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              return _ProfileMediaTile(
                index: index,
                item: mediaItems[index],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (context) => ProfileMediaViewer(
                      item: mediaItems[index],
                      profileName: profileName,
                      avatarUrl: avatarUrl,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ProfileMediaTile extends StatelessWidget {
  const _ProfileMediaTile({
    required this.index,
    required this.item,
    required this.onTap,
  });

  final int index;
  final ProfileMediaPreviewItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      image: true,
      label: 'Profile media item ${index + 1}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('profile-media-tile-$index'),
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: index == 0 ? AppColors.primaryYellow : AppColors.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.card,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PromooImage(
                    imageUrl: item.imageUrl,
                    fallbackIcon: item.isVideo
                        ? Icons.play_circle_outline_rounded
                        : Icons.image_rounded,
                    semanticLabel: item.caption,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.brandBlack.withValues(alpha: 0.74),
                        ],
                      ),
                    ),
                  ),
                  if (item.isVideo)
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primaryYellow,
                        size: 38,
                      ),
                    ),
                  PositionedDirectional(
                    start: AppSpacing.sm,
                    end: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              size: 14,
                              color: AppColors.primaryYellow,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Flexible(
                              child: Text(
                                item.likesLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
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

List<ProfileMediaPreviewItem> _mediaItemsFrom(List<String> mediaUrls) {
  return [
    for (var i = 0; i < mediaUrls.length; i++)
      ProfileMediaPreviewItem(
        imageUrl: mediaUrls[i],
        caption: _captionFor(i),
        likesLabel: _likesFor(i),
        commentsLabel: _commentsFor(i),
        sharesLabel: _sharesFor(i),
        viewsLabel: _viewsFor(i),
        isVideo: _isVideo(mediaUrls[i]) || i == 0,
      ),
  ];
}

String _captionFor(int index) {
  const captions = [
    'Launch campaign spotlight',
    'Cafe opening story',
    'Product feature moment',
    'Campaign planning preview',
    'Wellness creator recap',
    'Creator partnership highlight',
  ];
  return captions[index % captions.length];
}

String _likesFor(int index) {
  const values = ['12.4K', '9.8K', '8.2K', '6.7K', '5.9K', '4.6K'];
  return values[index % values.length];
}

String _commentsFor(int index) {
  const values = ['420', '318', '264', '190', '155', '122'];
  return values[index % values.length];
}

String _sharesFor(int index) {
  const values = ['86', '64', '52', '41', '35', '28'];
  return values[index % values.length];
}

String _viewsFor(int index) {
  const values = ['48.2K', '39.6K', '31.4K', '26.8K', '22.1K', '18.5K'];
  return values[index % values.length];
}

bool _isVideo(String mediaUrl) {
  final normalized = mediaUrl.toLowerCase();
  return normalized.contains('video') ||
      normalized.contains('reel') ||
      normalized.endsWith('.mp4');
}
