import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_colors.dart';

/// Take-photo/choose-from-gallery bottom sheet shared by every local-image
/// picker in the app (avatar, story, …) — extend here rather than forking a
/// per-screen copy.
Future<ImageSource?> showImageSourceSheet(
  BuildContext context,
  AppLocalizations l10n,
) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: context.colors.elevatedSurface,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l10n.profileEditTakePhoto),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l10n.profileEditChooseFromGallery),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );
}
