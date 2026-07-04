import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_service.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, this.onTap});

  final PromooService service;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceImage(service: service),
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
                        service.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (service.price != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        service.price!.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ],
                ),
                if (service.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    service.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (service.category != null)
                      _ServiceMetaChip(label: service.category!.name),
                    if (service.provider != null)
                      _ServiceMetaChip(label: service.provider!.name),
                    if (service.deliveryDays != null)
                      _ServiceMetaChip(
                        label: '${service.deliveryDays} day delivery',
                      ),
                    if (service.price == null)
                      const _ServiceMetaChip(label: 'Contact for pricing'),
                    if (service.location != null)
                      _ServiceMetaChip(label: service.location!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  const _ServiceImage({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.imageUrls.isEmpty ? null : service.imageUrls.first;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: PromooImage(
        imageUrl: imageUrl,
        semanticLabel: service.title,
        fallbackIcon: Icons.storefront_rounded,
      ),
    );
  }
}

class _ServiceMetaChip extends StatelessWidget {
  const _ServiceMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
