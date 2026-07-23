import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../reports/domain/entities/report_draft.dart';
import '../../../reports/presentation/report_sheet.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_controller.dart';

class HomeStoryViewer extends ConsumerStatefulWidget {
  const HomeStoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  }) : assert(stories.length > 0);

  final List<HomeStory> stories;
  final int initialIndex;

  @override
  ConsumerState<HomeStoryViewer> createState() => _HomeStoryViewerState();
}

class _HomeStoryViewerState extends ConsumerState<HomeStoryViewer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  late int _currentGroupIndex;
  late int _currentItemIndex;

  /// A press shorter than this counts as a tap (navigate); longer means the
  /// finger was held to pause, so releasing just resumes without navigating.
  static const _holdThresholdMs = 220;
  DateTime? _pressDownAt;

  HomeStory get _story => widget.stories[_currentGroupIndex];
  List<HomeStoryItem> get _items => _story.effectiveItems;
  HomeStoryItem get _item => _items[_currentItemIndex];

  /// Stories are grouped by author (`HomeStory.id` is the author's profile
  /// id — see `HomeStoryDto.groupedFromJson`), so this is true for every item
  /// in the group, not just the one currently showing.
  bool get _isOwnStory {
    final myId = ref.read(authControllerProvider).session?.user.id;
    return myId != null && myId == _story.id;
  }

  @override
  void initState() {
    super.initState();
    _currentGroupIndex = widget.initialIndex
        .clamp(0, widget.stories.length - 1)
        .toInt();
    _currentItemIndex = 0;
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

    // Full-screen media is an immersive surface: always the dark treatment,
    // regardless of the selected theme mode.
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: AppColors.brandBlack,
        body: _buildViewerBody(context, displayName),
      ),
    );
  }

  Widget _buildViewerBody(BuildContext context, String displayName) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Pause the instant a finger touches down — no long-press delay. On
      // release we decide tap vs hold by how long it was held: a quick press
      // navigates (advance/back by tap position); a longer press was a
      // deliberate hold-to-pause, so we just resume. This replaces
      // `onLongPressStart`, whose built-in ~500ms recognition delay was the
      // lag the owner noticed before the story would pause.
      onTapDown: (_) {
        _pressDownAt = DateTime.now();
        _progressController.stop();
      },
      onTapUp: (details) {
        final held = _pressDownAt == null
            ? 0
            : DateTime.now().difference(_pressDownAt!).inMilliseconds;
        _pressDownAt = null;
        _progressController.forward();
        if (held < _holdThresholdMs) {
          _handleStoryTap(context, details);
        }
      },
      onTapCancel: () {
        _pressDownAt = null;
        if (mounted) {
          _progressController.forward();
        }
      },
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 420) {
          Navigator.of(context).pop();
        }
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < 300) return;

        if (velocity > 0) {
          // Swiped right -> Previous story group (LTR behavior)
          _showPreviousStoryGroup();
        } else {
          // Swiped left -> Next story group (LTR behavior)
          _showNextStoryGroup();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: PromooImage(
                key: ValueKey('${_story.id}-${_item.id}'),
                imageUrl: _item.imageUrl ?? _story.imageUrl,
                semanticLabel: _item.title,
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
                      count: _items.length,
                      currentIndex: _currentItemIndex,
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
                          color: AppColors.brandYellow,
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
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.dark.textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                        ),
                      ),
                      if (_isOwnStory)
                        IconButton(
                          tooltip: AppLocalizations.of(
                            context,
                          ).homeStoryViewerMoreTooltip,
                          onPressed: _showOwnStoryMenu,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.dark.textPrimary,
                          ),
                        )
                      else
                        IconButton(
                          tooltip: AppLocalizations.of(context).reportAction,
                          onPressed: _showOtherStoryMenu,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.dark.textPrimary,
                          ),
                        ),
                      IconButton(
                        tooltip: AppLocalizations.of(
                          context,
                        ).homeStoryViewerCloseTooltip,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.dark.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Caption box only when the story actually has a title —
                  // most don't, and an empty/placeholder box looked wrong.
                  if (_item.title.trim().isNotEmpty)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.dark.overlay,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: AppColors.brandYellow.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                        child: Text(
                          _item.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.dark.textPrimary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleProgressStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) {
      return;
    }
    _showNextStoryItem();
  }

  void _handleStoryTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.sizeOf(context).width;
    if (details.localPosition.dx < width * 0.35) {
      _showPreviousStoryItem();
      return;
    }
    _showNextStoryItem();
  }

  void _showNextStoryItem() {
    if (_currentItemIndex < _items.length - 1) {
      _showStory(_currentGroupIndex, _currentItemIndex + 1);
      return;
    }

    if (_currentGroupIndex < widget.stories.length - 1) {
      _showStory(_currentGroupIndex + 1, 0);
      return;
    }

    // Last item of the last story — tapping "next" here should behave like
    // swiping past the end (see `_showStory`'s out-of-range case): close the
    // viewer, not freeze on the last frame.
    _progressController.stop();
    Navigator.of(context).pop();
  }

  /// Pauses progress while showing the actions menu (Report story),
  /// then opens the report sheet if selected.
  Future<void> _showOtherStoryMenu() async {
    final l10n = AppLocalizations.of(context);
    _progressController.stop();

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.elevatedSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: AppColors.error),
                title: Text(
                  l10n.reportAction,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () => Navigator.of(sheetContext).pop('report'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (action == 'report') {
      await showReportSheet(
        context,
        ref,
        reportedId: _item.id,
        reportedType: ReportedType.story,
      );
    }

    if (mounted) {
      _progressController.forward();
    }
  }

  /// Pauses progress, offers "Delete story" for the current item, confirms,
  /// then deletes and closes the viewer (simplest correct behavior — the
  /// underlying `widget.stories` list is immutable/owned by Home, so this
  /// doesn't try to splice the item out and keep viewing in place).
  Future<void> _showOwnStoryMenu() async {
    final l10n = AppLocalizations.of(context);
    _progressController.stop();

    final wantsDelete = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: context.colors.elevatedSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                title: Text(
                  l10n.homeStoryViewerDeleteAction,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                onTap: () => Navigator.of(sheetContext).pop(true),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) {
      return;
    }
    if (wantsDelete != true) {
      _progressController.forward();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.homeStoryViewerDeleteConfirmTitle),
        content: Text(l10n.homeStoryViewerDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.homeStoryViewerCancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.homeStoryViewerDeleteConfirmButton,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }
    if (confirmed != true) {
      _progressController.forward();
      return;
    }

    final result = await ref.read(homeRepositoryProvider).deleteStory(_item.id);
    if (!mounted) {
      return;
    }

    result.when(
      success: (_) {
        ref.read(homeControllerProvider.notifier).refresh();
        Navigator.of(context).pop();
      },
      failure: (failure) {
        _progressController.forward();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  void _showPreviousStoryItem() {
    if (_currentItemIndex > 0) {
      _showStory(_currentGroupIndex, _currentItemIndex - 1);
      return;
    }

    if (_currentGroupIndex <= 0) {
      return;
    }

    final previousGroupIndex = _currentGroupIndex - 1;
    final previousItems = widget.stories[previousGroupIndex].effectiveItems;
    _showStory(previousGroupIndex, previousItems.length - 1);
  }

  void _showNextStoryGroup() {
    _showStory(_currentGroupIndex + 1, 0);
  }

  void _showPreviousStoryGroup() {
    if (_currentGroupIndex > 0) {
      _showStory(_currentGroupIndex - 1, 0);
    }
  }

  void _showStory(int nextGroupIndex, int nextItemIndex) {
    if (nextGroupIndex < 0 || nextGroupIndex >= widget.stories.length) {
      _progressController.stop();
      Navigator.of(context).pop();
      return;
    }

    final nextItems = widget.stories[nextGroupIndex].effectiveItems;
    final safeItemIndex = nextItemIndex.clamp(0, nextItems.length - 1).toInt();

    setState(() {
      _currentGroupIndex = nextGroupIndex;
      _currentItemIndex = safeItemIndex;
    });
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
                    backgroundColor: AppColors.dark.textPrimary.withValues(alpha: 0.28,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.brandYellow,
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
            AppColors.brandBlack.withValues(alpha: 0.56),
            Colors.transparent,
            AppColors.brandBlack.withValues(alpha: 0.7),
          ],
          stops: const [0, 0.48, 1],
        ),
      ),
    );
  }
}
