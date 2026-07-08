import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/search_result.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.result, this.onTap});

  final SearchResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final priceLabel = switch (result) {
      SearchServiceResult(:final price) => price?.label,
      SearchOfferResult(:final price) => price?.label,
      _ => null,
    };

    return PromooCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResultVisual(result: result),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        result.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (priceLabel != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        priceLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colors.accent,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                _ResultMeta(result: result),
                if (result.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    result.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (result.provider != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    result.provider!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultVisual extends StatelessWidget {
  const _ResultVisual({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    final icon = switch (result.type) {
      SearchResultType.profile => Icons.person_rounded,
      SearchResultType.service => Icons.handshake_rounded,
      SearchResultType.offer => Icons.local_offer_rounded,
      SearchResultType.ad => Icons.campaign_rounded,
      SearchResultType.unknown => Icons.search_rounded,
    };

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: context.colors.elevatedSurface,
        borderRadius: result.type == SearchResultType.profile
            ? AppRadius.pill
            : AppRadius.card,
        border: Border.all(color: context.colors.border),
        image: result.imageUrl == null
            ? null
            : DecorationImage(
                image: NetworkImage(result.imageUrl!),
                fit: BoxFit.cover,
              ),
      ),
      child: result.imageUrl == null
          ? Icon(icon, color: context.colors.accent)
          : null,
    );
  }
}

class _ResultMeta extends StatelessWidget {
  const _ResultMeta({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    final current = result;
    SearchProfileResult? profile;
    if (current is SearchProfileResult) {
      profile = current;
    }
    SearchOfferResult? offer;
    if (current is SearchOfferResult) {
      offer = current;
    }
    final labels = <String>[
      _typeLabel(result),
      if (result.subtitle != null) result.subtitle!,
      if (profile?.location != null) profile!.location!,
      if (profile?.isVerified ?? false) 'Verified',
      if (offer?.isFeatured ?? false) 'Featured',
    ];

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: AppRadius.pill,
              border: Border.all(color: context.colors.border),
            ),
            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
          ),
      ],
    );
  }

  String _typeLabel(SearchResult result) {
    return switch (result.type) {
      SearchResultType.profile => 'Profile',
      SearchResultType.service => 'Service',
      SearchResultType.offer => 'Offer',
      SearchResultType.ad => 'Ad',
      SearchResultType.unknown => 'Result',
    };
  }
}
