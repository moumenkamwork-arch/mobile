import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';

class ProfileMediaPreviewItem {
  const ProfileMediaPreviewItem({
    required this.imageUrl,
    required this.caption,
    required this.likesLabel,
    required this.commentsLabel,
    required this.sharesLabel,
    required this.viewsLabel,
    this.isVideo = false,
  });

  final String imageUrl;
  final String caption;
  final String likesLabel;
  final String commentsLabel;
  final String sharesLabel;
  final String viewsLabel;
  final bool isVideo;
}

class ProfileMediaViewer extends StatelessWidget {
  const ProfileMediaViewer({
    super.key,
    required this.item,
    required this.profileName,
    this.avatarUrl,
  });

  final ProfileMediaPreviewItem item;
  final String profileName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    // Full-screen media is an immersive surface: always the dark treatment,
    // regardless of the selected theme mode.
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        key: const ValueKey('profile-media-viewer'),
        backgroundColor: AppColors.brandBlack,
        body: _buildViewerBody(context),
      ),
    );
  }

  Widget _buildViewerBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: PromooImage(
              imageUrl: item.imageUrl,
              fallbackIcon: item.isVideo
                  ? Icons.play_circle_outline_rounded
                  : Icons.image_rounded,
              semanticLabel: item.caption,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: [
                    AppColors.brandBlack.withValues(alpha: 0.62),
                    Colors.transparent,
                    AppColors.brandBlack.withValues(alpha: 0.82),
                  ],
                  stops: const [0, 0.44, 1],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.sm,
            start: AppSpacing.sm,
            child: IconButton.filled(
              tooltip: AppLocalizations.of(context).profileMediaCloseTooltip,
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.overlay,
                foregroundColor: AppColors.textPrimary,
              ),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.lg,
            end: AppSpacing.md,
            bottom: 118,
            child: _MediaEngagementRail(item: item),
          ),
          PositionedDirectional(
            start: AppSpacing.md,
            end: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: _MediaCaption(
              item: item,
              profileName: profileName,
              avatarUrl: avatarUrl,
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaEngagementRail extends StatelessWidget {
  const _MediaEngagementRail({required this.item});

  final ProfileMediaPreviewItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _EngagementAction(
          icon: Icons.favorite_rounded,
          label: l10n.profileStatsLikes,
          value: item.likesLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        _EngagementAction(
          icon: Icons.chat_bubble_rounded,
          label: l10n.profileMediaCommentsLabel,
          value: item.commentsLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        _EngagementAction(
          icon: Icons.ios_share_rounded,
          label: l10n.profileMediaShareLabel,
          value: item.sharesLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        _EngagementAction(
          icon: Icons.visibility_rounded,
          label: l10n.profileStatsViews,
          value: item.viewsLabel,
        ),
      ],
    );
  }
}

class _EngagementAction extends StatelessWidget {
  const _EngagementAction({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $value',
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.overlay,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MediaCaption extends StatelessWidget {
  const _MediaCaption({
    required this.item,
    required this.profileName,
    this.avatarUrl,
  });

  final ProfileMediaPreviewItem item;
  final String profileName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.overlay,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brandBlack,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryYellow),
            ),
            child: ClipOval(
              child: PromooImage(
                imageUrl: avatarUrl,
                fallbackIcon: Icons.person_rounded,
                semanticLabel: profileName,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  item.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
