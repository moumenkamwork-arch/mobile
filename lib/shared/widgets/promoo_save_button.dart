import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/saved/presentation/controllers/saved_controller.dart';
import '../../theme/app_colors.dart';

/// Bookmark icon toggle used on content-detail screens (offer/ad/service).
/// Backed live by `POST /saved` + `DELETE /saved/:id` via [SavedController].
class PromooSaveButton extends ConsumerWidget {
  const PromooSaveButton({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  final String itemId;
  final String itemType;
  final String title;
  final String? subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(savedControllerProvider);
    final saved = ref.read(savedControllerProvider.notifier).isSaved(itemId);

    return IconButton(
      tooltip: saved
          ? l10n.savedButtonUnsaveTooltip
          : l10n.savedButtonSaveTooltip,
      onPressed: state.status == SavedStatus.loading
          ? null
          : () => ref
                .read(savedControllerProvider.notifier)
                .toggle(
                  itemId: itemId,
                  itemType: itemType,
                  title: title,
                  subtitle: subtitle,
                  imageUrl: imageUrl,
                ),
      icon: Icon(
        saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: saved ? context.colors.primaryYellow : null,
      ),
    );
  }
}
