import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../saved/domain/entities/saved_item.dart';
import '../../../saved/presentation/controllers/saved_controller.dart';

/// "Saved" page: bookmarked offers / services / ads / profiles, from
/// `GET /saved` (backend hydrates each row's full item). Wired in Phase 8.
class SavedItemsScreen extends ConsumerWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(savedControllerProvider);

    return PromooSubpageScaffold(
      title: l10n.menuSaved,
      child: switch (state.status) {
        SavedStatus.loading => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooLoadingIndicator(message: l10n.menuSaved),
        ),
        SavedStatus.error => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooErrorState(
            title: l10n.commonSomethingWentWrong,
            message: state.failure?.message ?? l10n.commonSomethingWentWrong,
            onRetry: () => ref.read(savedControllerProvider.notifier).retry(),
          ),
        ),
        SavedStatus.empty => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooEmptyState(
            title: l10n.profileSavedEmptyTitle,
            message: l10n.profileSavedEmptyMessage,
          ),
        ),
        SavedStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in state.items) ...[
              _SavedCard(
                item: item,
                onRemove: () =>
                    ref.read(savedControllerProvider.notifier).remove(item.id),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      },
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.item, required this.onRemove});

  final SavedItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = [
      item.itemType,
      if (item.subtitle != null && item.subtitle!.isNotEmpty) item.subtitle,
    ].join(' • ');

    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: PromooImage(imageUrl: item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.profileSavedRemoveTooltip,
            onPressed: onRemove,
            icon: Icon(Icons.bookmark_rounded, color: context.colors.accent),
          ),
        ],
      ),
    );
  }
}
