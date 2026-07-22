import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/upload/data/repositories/upload_repository_impl.dart';
import '../../features/upload/domain/entities/uploaded_media.dart';
import '../../core/utils/result.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'promoo_image.dart';
import 'promoo_image_source_sheet.dart';

/// A tap-to-upload image field: empty state shows a dashed box; on tap it picks
/// a local image (camera/gallery sheet), uploads it to [bucket] via the shared
/// Upload infra, and reports the returned Storage URL through [onChanged]. Once
/// set it shows a thumbnail with replace/remove. Used by the Add Offer / Add
/// Service / Add Ad forms — the two-step "upload → get URL → attach to the
/// entity's payload" flow, same as avatar/story.
class PromooImageUploadField extends ConsumerStatefulWidget {
  const PromooImageUploadField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.bucket,
    required this.label,
    required this.caption,
    this.relatedTo,
    this.icon = Icons.add_photo_alternate_outlined,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final UploadBucket bucket;
  final UploadRelatedTo? relatedTo;
  final String label;
  final String caption;
  final IconData icon;

  @override
  ConsumerState<PromooImageUploadField> createState() =>
      _PromooImageUploadFieldState();
}

class _PromooImageUploadFieldState
    extends ConsumerState<PromooImageUploadField> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    if (_isUploading) {
      return _box(
        colors: colors,
        child: Column(
          children: [
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.addCommonUploading, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    final value = widget.value;
    if (value != null && value.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: colors.border),
        ),
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.input,
              child: SizedBox(
                width: 56,
                height: 56,
                child: PromooImage(imageUrl: value, semanticLabel: widget.label),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Wrap(
                spacing: AppSpacing.xs,
                children: [
                  TextButton.icon(
                    onPressed: _pickAndUpload,
                    icon: const Icon(Icons.autorenew_rounded, size: 18),
                    label: Text(l10n.addCommonReplaceImage),
                  ),
                  TextButton.icon(
                    onPressed: () => widget.onChanged(null),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      l10n.addCommonRemoveImage,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _pickAndUpload,
      borderRadius: AppRadius.card,
      child: _box(
        colors: colors,
        child: Column(
          children: [
            Icon(widget.icon, color: colors.textSecondary, size: 30),
            const SizedBox(height: AppSpacing.xs),
            Text(widget.label, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xxs),
            Text(widget.caption, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _box({required AppThemeColors colors, required Widget child}) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.borderStrong),
      ),
      child: Center(child: child),
    );
  }

  Future<void> _pickAndUpload() async {
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
        maxWidth: 1440,
      );
    } catch (_) {
      return;
    }
    if (picked == null || !mounted) {
      return;
    }

    setState(() => _isUploading = true);
    final result = await ref.read(uploadRepositoryProvider).uploadImage(
      filePath: picked.path,
      bucket: widget.bucket,
      relatedTo: widget.relatedTo,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isUploading = false);

    switch (result) {
      case Success(data: final media):
        widget.onChanged(media.fileUrl);
      case Failure(failure: final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }
}
