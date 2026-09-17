import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/profile_controller.dart';
import 'profile_media_viewer.dart';

class ProfileMediaSection extends ConsumerWidget {
  const ProfileMediaSection({
    super.key,
    required this.mediaUrls,
    required this.profileName,
    this.avatarUrl,
    this.isOwner = false,
  });

  final List<String> mediaUrls;
  final String profileName;
  final String? avatarUrl;
  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItems = _mediaItemsFrom(mediaUrls);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromooSectionHeader(
          title: l10n.profileMediaTitle,
          subtitle: l10n.profileMediaSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (mediaItems.isEmpty)
          PromooEmptyState(
            title: l10n.profileMediaEmptyTitle,
            message: l10n.profileMediaEmptyMessage,
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
              final item = mediaItems[index];
              return _ProfileMediaTile(
                index: index,
                item: item,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (context) => ProfileMediaViewer(
                      item: item,
                      profileName: profileName,
                      avatarUrl: avatarUrl,
                      isOwner: isOwner,
                      onDelete: isOwner
                          ? () => ref
                                .read(profileControllerProvider.notifier)
                                .deleteMedia(item.imageUrl)
                          : null,
                    ),
                  ),
                ),
                onLongPress: isOwner
                    ? () => _confirmAndDeleteMedia(context, ref, item)
                    : null,
              );
            },
          ),
      ],
    );
  }

  void _confirmAndDeleteMedia(
    BuildContext context,
    WidgetRef ref,
    ProfileMediaPreviewItem item,
  ) {
    showDeleteMediaConfirmation(
      context,
      onDelete: () => ref
          .read(profileControllerProvider.notifier)
          .deleteMedia(item.imageUrl),
    );
  }
}

class _ProfileMediaTile extends StatelessWidget {
  const _ProfileMediaTile({
    required this.index,
    required this.item,
    required this.onTap,
    this.onLongPress,
  });

  final int index;
  final ProfileMediaPreviewItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      image: true,
      label: AppLocalizations.of(context).profileMediaItemSemantic(index + 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('profile-media-tile-$index'),
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: AppRadius.card,
          child: Ink(
            decoration: BoxDecoration(
              color: context.colors.cardSurface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: index == 0
                    ? context.colors.accent
                    : context.colors.border,
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
                      // Over the photo scrim: brand yellow in both themes.
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.brandYellow,
                        size: 38,
                      ),
                    ),
                  PositionedDirectional(
                    start: AppSpacing.sm,
                    end: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    // Over the dark photo scrim in both themes.
                    child: Text(
                      item.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.dark.textPrimary,
                      ),
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

bool _isVideo(String mediaUrl) {
  final normalized = mediaUrl.toLowerCase();
  return normalized.contains('video') ||
      normalized.contains('reel') ||
      normalized.endsWith('.mp4');
}
