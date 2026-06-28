import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

class HomeStoryViewer extends StatefulWidget {
  const HomeStoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  }) : assert(stories.length > 0);

  final List<HomeStory> stories;
  final int initialIndex;

  @override
  State<HomeStoryViewer> createState() => _HomeStoryViewerState();
}

class _HomeStoryViewerState extends State<HomeStoryViewer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  late int _currentIndex;

  HomeStory get _story => widget.stories[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex
        .clamp(0, widget.stories.length - 1)
        .toInt();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener(_handleProgressStatus);
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController
      ..removeStatusListener(_handleProgressStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _story.profileName ?? _story.title;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => _handleStoryTap(context, details),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: PromooImage(
                  key: ValueKey(_story.id),
                  imageUrl: _story.imageUrl,
                  semanticLabel: _story.title,
                  fallbackIcon: Icons.photo_camera_rounded,
                ),
              ),
            ),
            const Positioned.fill(child: _StoryOverlay()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      label: 'Story progress',
                      child: _StoryProgressBars(
                        count: widget.stories.length,
                        currentIndex: _currentIndex,
                        animation: _progressController,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsetsDirectional.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryYellow,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: PromooImage(
                              imageUrl:
                                  _story.profileAvatarUrl ?? _story.imageUrl,
                              semanticLabel: displayName,
                              fallbackIcon: Icons.person_rounded,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close story',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.overlay,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: AppColors.primaryYellow.withValues(
                            alpha: 0.22,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                        child: Text(
                          _story.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleProgressStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) {
      return;
    }
    if (_currentIndex < widget.stories.length - 1) {
      _showStory(_currentIndex + 1);
    }
  }

  void _handleStoryTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.sizeOf(context).width;
    if (details.localPosition.dx < width * 0.35) {
      _showStory(_currentIndex - 1);
      return;
    }
    _showStory(_currentIndex + 1);
  }

  void _showStory(int nextIndex) {
    if (nextIndex < 0) {
      return;
    }
    if (nextIndex >= widget.stories.length) {
      _progressController.stop();
      return;
    }

    setState(() => _currentIndex = nextIndex);
    _progressController.forward(from: 0);
  }
}

class _StoryProgressBars extends StatelessWidget {
  const _StoryProgressBars({
    required this.count,
    required this.currentIndex,
    required this.animation,
  });

  final int count;
  final int currentIndex;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          children: [
            for (var index = 0; index < count; index++) ...[
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.pill,
                  child: LinearProgressIndicator(
                    value: _valueForIndex(index),
                    minHeight: 3,
                    backgroundColor: AppColors.textPrimary.withValues(
                      alpha: 0.28,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryYellow,
                    ),
                  ),
                ),
              ),
              if (index < count - 1) const SizedBox(width: AppSpacing.xxs),
            ],
          ],
        );
      },
    );
  }

  double _valueForIndex(int index) {
    if (index < currentIndex) {
      return 1;
    }
    if (index > currentIndex) {
      return 0;
    }
    return animation.value;
  }
}

class _StoryOverlay extends StatelessWidget {
  const _StoryOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.56),
            Colors.transparent,
            AppColors.background.withValues(alpha: 0.7),
          ],
          stops: const [0, 0.48, 1],
        ),
      ),
    );
  }
}
