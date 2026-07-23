import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_image_source_sheet.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../upload/data/repositories/upload_repository_impl.dart';
import '../../../upload/domain/entities/uploaded_media.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_controller.dart';
import 'home_story_viewer.dart';

class HomeStoryStrip extends ConsumerWidget {
  const HomeStoryStrip({super.key, required this.stories, this.onSeeAll});

  final List<HomeStory> stories;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isSignedIn = ref.watch(authControllerProvider).session != null;

    // Nothing to browse and no "add" tile to offer (guest) — take up no space.
    if (!isSignedIn && stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: l10n.homeSectionStoriesTitle,
          subtitle: l10n.homeSectionStoriesSubtitle,
          actionLabel: onSeeAll == null ? null : l10n.commonSeeAll,
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length + (isSignedIn ? 1 : 0),
            separatorBuilder: (context, index) {
              return const SizedBox(width: AppSpacing.md);
            },
            itemBuilder: (context, index) {
              if (isSignedIn && index == 0) {
                return const _AddStoryTile();
              }
              final storyIndex = isSignedIn ? index - 1 : index;
              return _HomeStoryItem(
                story: stories[storyIndex],
                onTap: () => _openStoryViewer(context, storyIndex),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openStoryViewer(BuildContext context, int initialIndex) {
    // rootNavigator: true pushes ABOVE the shell (and its bottom nav bar) so
    // the story plays truly fullscreen, like Instagram — otherwise the nav bar
    // stayed visible under the story.
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeStoryViewer(stories: stories, initialIndex: initialIndex);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _HomeStoryItem extends StatelessWidget {
  const _HomeStoryItem({required this.story, required this.onTap});

  final HomeStory story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsetsDirectional.all(2),
                // Story ring is the brand highlighter in both themes.
                decoration: const BoxDecoration(
                  color: AppColors.brandYellow,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: PromooImage(
                    imageUrl: story.profileAvatarUrl ?? story.imageUrl,
                    semanticLabel: story.profileName ?? story.title,
                    fallbackIcon: Icons.person_rounded,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                story.profileName ?? story.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// First tile in the strip when signed in: pick a local image (camera or
/// gallery, same sheet as the avatar picker) → upload it
/// (`bucket: stories`, `related: story`) → `POST /stories` with the returned
/// URL → refresh Home so the new story shows immediately.
class _AddStoryTile extends ConsumerStatefulWidget {
  const _AddStoryTile();

  @override
  ConsumerState<_AddStoryTile> createState() => _AddStoryTileState();
}

class _AddStoryTileState extends ConsumerState<_AddStoryTile> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).session?.user;
    final profileAvatarUrl = ref.watch(
      profileControllerProvider.select((state) => state.profile?.avatarUrl),
    );
    final ownerAvatarUrl = profileAvatarUrl ?? user?.avatarUrl;

    return SizedBox(
      width: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isUploading ? null : _addStory,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colors.border),
                      ),
                      child: ClipOval(
                        child: _isUploading
                            ? ColoredBox(
                                color: AppColors.brandBlack.withValues(
                                  alpha: 0.55,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.brandYellow,
                                    ),
                                  ),
                                ),
                              )
                            : PromooImage(
                                imageUrl: ownerAvatarUrl,
                                semanticLabel: l10n.homeStoryYourStory,
                                fallbackIcon: Icons.person_rounded,
                              ),
                      ),
                    ),
                    if (!_isUploading)
                      PositionedDirectional(
                        bottom: -2,
                        end: -2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.brandYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: AppColors.brandBlack,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isUploading
                    ? l10n.homeStoryUploading
                    : l10n.homeStoryYourStory,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addStory() async {
    final l10n = AppLocalizations.of(context);
    final source = await showImageSourceSheet(context, l10n);
    if (source == null || !mounted) {
      return;
    }

    final XFile? picked;
    try {
      picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );
    } catch (_) {
      return;
    }
    if (picked == null || !mounted) {
      return;
    }

    setState(() => _isUploading = true);

    final uploadResult = await ref
        .read(uploadRepositoryProvider)
        .uploadImage(
          filePath: picked.path,
          bucket: UploadBucket.stories,
          relatedTo: UploadRelatedTo.story,
        );
    if (!mounted) {
      return;
    }

    switch (uploadResult) {
      case Success(data: final media):
        final createResult = await ref
            .read(homeRepositoryProvider)
            .createStory(media.fileUrl);
        if (!mounted) {
          return;
        }
        setState(() => _isUploading = false);
        createResult.when(
          success: (_) {
            ref.read(homeControllerProvider.notifier).refresh();
            _showNotice(l10n.homeStoryAdded);
          },
          failure: (failure) => _showNotice(failure.message),
        );
      case Failure(failure: final failure):
        setState(() => _isUploading = false);
        _showNotice(failure.message);
    }
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
