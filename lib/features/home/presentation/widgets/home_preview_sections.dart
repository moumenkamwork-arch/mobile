import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

class HomeServicesPreviewSection extends StatelessWidget {
  const HomeServicesPreviewSection({super.key, required this.services});

  final List<HomeServicePreview> services;

  @override
  Widget build(BuildContext context) {
    return _PreviewSection(
      title: 'Services',
      subtitle: 'Explore providers ready for contact',
      children: [
        for (final service in services.take(3))
          _PreviewTile(
            title: service.title,
            subtitle: _joinNonEmpty([service.categoryName, service.location]),
            fallbackIcon: Icons.storefront_rounded,
            onTap: () => context.go(AppRoutes.serviceById(service.id)),
          ),
      ],
    );
  }
}

class HomeOffersPreviewSection extends StatelessWidget {
  const HomeOffersPreviewSection({super.key, required this.offers});

  final List<HomeOfferPreview> offers;

  @override
  Widget build(BuildContext context) {
    return _PreviewSection(
      title: 'Promotions',
      subtitle: 'Available offers from Promoo partners',
      children: [
        for (final offer in offers.take(3))
          _PreviewTile(
            title: offer.title,
            subtitle: offer.subtitle,
            fallbackIcon: Icons.local_offer_rounded,
            onTap: () => context.go(
              AppRoutes.homeItemDetail(offer.detailType.routeValue, offer.id),
            ),
          ),
      ],
    );
  }
}

class HomeProfilesPreviewSection extends StatelessWidget {
  const HomeProfilesPreviewSection({super.key, required this.profiles});

  final List<HomeProfilePreview> profiles;

  @override
  Widget build(BuildContext context) {
    return _PreviewSection(
      title: 'Featured profiles',
      subtitle: 'Creators and partners to discover',
      children: [
        for (final profile in profiles.take(3))
          _PreviewTile(
            title: profile.name,
            subtitle: _joinNonEmpty([
              if (profile.username != null) '@${profile.username}',
              profile.accountType,
            ]),
            fallbackIcon: profile.isVerified
                ? Icons.verified_rounded
                : Icons.person_rounded,
          ),
      ],
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(title: title, subtitle: subtitle),
        const SizedBox(height: AppSpacing.md),
        ...children.expand((child) sync* {
          yield child;
          if (child != children.last) {
            yield const SizedBox(height: AppSpacing.xs);
          }
        }),
      ],
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.title,
    required this.fallbackIcon,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(fallbackIcon, color: AppColors.primaryYellow, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
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

String? _joinNonEmpty(List<String?> values) {
  final parts = values
      .whereType<String>()
      .where((value) => value.trim().isNotEmpty)
      .toList(growable: false);

  if (parts.isEmpty) {
    return null;
  }
  return parts.join(' - ');
}
