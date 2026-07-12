import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// "Saved" page: bookmarked offers and services.
///
/// Phase A shows demo bookmarks (fictional Promoo demo content) with local
/// remove; the integration phase swaps this to backend `GET /saved`.
class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItem {
  const _SavedItem({
    required this.id,
    required this.title,
    required this.type,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String type;
  final String subtitle;
  final String imageUrl;
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  final _items = <_SavedItem>[
    const _SavedItem(
      id: 'saved-1',
      title: 'Cafe opening spotlight',
      type: 'Offer',
      subtitle: 'Saffron Social Studio • 149 AED',
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=640&q=80',
    ),
    const _SavedItem(
      id: 'saved-2',
      title: 'Instagram Story Promotion',
      type: 'Service',
      subtitle: 'Beauty & Wellness • 99 AED',
      imageUrl:
          'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?auto=format&fit=crop&w=640&q=80',
    ),
    const _SavedItem(
      id: 'saved-3',
      title: 'Weekend flash deal',
      type: 'Offer',
      subtitle: 'Framehouse Events • 199 AED',
      imageUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=640&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooSubpageScaffold(
      title: l10n.menuSaved,
      child: _items.isEmpty
          ? Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
              child: PromooEmptyState(
                title: l10n.profileSavedEmptyTitle,
                message: l10n.profileSavedEmptyMessage,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in _items) ...[
                  PromooCard(
                    padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: PromooImage(
                              imageUrl: item.imageUrl,
                              fit: BoxFit.cover,
                            ),
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
                                '${item.type} • ${item.subtitle}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.profileSavedRemoveTooltip,
                          onPressed: () {
                            setState(() {
                              _items.removeWhere((it) => it.id == item.id);
                            });
                          },
                          icon: Icon(
                            Icons.bookmark_rounded,
                            color: context.colors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
    );
  }
}
