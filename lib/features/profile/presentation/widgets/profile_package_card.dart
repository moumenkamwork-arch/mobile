import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_detail_chip.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_profile.dart';

class ProfilePackageCard extends StatelessWidget {
  const ProfilePackageCard({super.key, required this.package});

  final ProfilePackage package;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PackageIcon(package: package),
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
                        package.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (package.price != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        package.price!.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colors.accent,
                        ),
                      ),
                    ],
                  ],
                ),
                if (package.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    package.description!,
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
                    if (package.categoryName != null)
                      PromooDetailChip(label: package.categoryName!),
                    if (package.deliveryDays != null)
                      PromooDetailChip(
                        label: l10n.servicesDeliveryDaysLabel(
                          package.deliveryDays!,
                        ),
                      ),
                    PromooDetailChip(label: l10n.profilePackageContactOnly),
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

class _PackageIcon extends StatelessWidget {
  const _PackageIcon({required this.package});

  final ProfilePackage package;

  @override
  Widget build(BuildContext context) {
    final imageUrl = package.imageUrls.isEmpty ? null : package.imageUrls.first;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: context.colors.elevatedSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.border),
        image: imageUrl == null
            ? null
            : DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: imageUrl == null
          ? Icon(Icons.local_offer_rounded, color: context.colors.accent)
          : null,
    );
  }
}
