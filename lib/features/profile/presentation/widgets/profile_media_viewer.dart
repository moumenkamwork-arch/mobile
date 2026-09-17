import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';

class ProfileMediaPreviewItem {
  const ProfileMediaPreviewItem({
    required this.imageUrl,
    required this.caption,
    this.isVideo = false,
  });

  final String imageUrl;
  final String caption;
  final bool isVideo;
}

class ProfileMediaViewer extends StatelessWidget {
  const ProfileMediaViewer({
    super.key,
    required this.item,
    required this.profileName,
    this.avatarUrl,
    this.isOwner = false,
    this.onDelete,
  });

  final ProfileMediaPreviewItem item;
  final String profileName;
  final String? avatarUrl;
  final bool isOwner;
  final Future<bool> Function()? onDelete;

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
    final l10n = AppLocalizations.of(context);
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
          if (isOwner && onDelete != null)
            PositionedDirectional(
              top: AppSpacing.sm,
              end: AppSpacing.sm,
              child: IconButton.filled(
                tooltip: l10n.profileMediaDeleteTooltip,
                onPressed: () => _confirmAndDelete(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.85),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
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

  void _confirmAndDelete(BuildContext context) {
    showDeleteMediaConfirmation(
      context,
      onConfirmed: () => Navigator.of(context).pop(),
      onDelete: () async => await onDelete?.call() ?? false,
    );
  }
}

/// Shared delete-confirmation dialog for a single profile media item.
///
/// [onConfirmed] runs right after the dialog closes and before [onDelete] —
/// used by the full-screen viewer to pop itself, since a long-press from the
/// grid has no extra screen to dismiss.
Future<void> showDeleteMediaConfirmation(
  BuildContext context, {
  required Future<bool> Function() onDelete,
  VoidCallback? onConfirmed,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.profileMediaDeleteTitle),
        content: Text(l10n.profileMediaDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              onConfirmed?.call();
              final success = await onDelete();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? l10n.profileMediaDeleteSuccess
                          : l10n.profileMediaDeleteFailure,
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.profileMediaDeleteConfirmAction),
          ),
        ],
      );
    },
  );
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
