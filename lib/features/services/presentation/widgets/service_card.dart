import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_detail_chip.dart';
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
    final l10n = AppLocalizations.of(context);
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
                          color: context.colors.accent,
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
                      PromooDetailChip(label: service.category!.name),
                    if (service.provider != null)
                      PromooDetailChip(label: service.provider!.name),
                    if (service.deliveryDays != null)
                      PromooDetailChip(
                        label: l10n.servicesDeliveryDaysLabel(
                          service.deliveryDays!,
                        ),
                      ),
                    if (service.price == null)
                      PromooDetailChip(label: l10n.commonContactForPricing),
                    if (service.location != null)
                      PromooDetailChip(label: service.location!),
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
        color: context.colors.elevatedSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.border),
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
