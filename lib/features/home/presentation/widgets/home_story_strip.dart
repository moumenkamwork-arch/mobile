import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

class HomeStoryStrip extends StatelessWidget {
  const HomeStoryStrip({super.key, required this.stories});

  final List<HomeStory> stories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooSectionHeader(
          title: 'Highlights',
          subtitle: 'Fresh stories from Promoo partners',
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
              return _HomeStoryItem(story: stories[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _HomeStoryItem extends StatelessWidget {
  const _HomeStoryItem({required this.story});

  final HomeStory story;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
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
            child: CircleAvatar(
              backgroundColor: AppColors.elevatedSurface,
              backgroundImage: story.imageUrl == null
                  ? null
                  : NetworkImage(story.imageUrl!),
              child: story.imageUrl == null
                  ? const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primaryYellow,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            story.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
