import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';
import 'home_story_viewer.dart';

class HomeStoryStrip extends StatelessWidget {
  const HomeStoryStrip({super.key, required this.stories, this.onSeeAll});

  final List<HomeStory> stories;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: 'Stories',
          subtitle: 'Fresh updates from Promoo partners',
          actionLabel: onSeeAll == null ? null : 'See All',
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: AppSpacing.md);
            },
            itemBuilder: (context, index) {
              return _HomeStoryItem(
                story: stories[index],
                onTap: () => _openStoryViewer(context, index),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openStoryViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
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
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
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
