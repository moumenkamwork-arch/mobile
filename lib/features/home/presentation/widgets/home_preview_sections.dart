import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';

enum HomeOfferPreviewLayout { hero, compact }

class HomeServicesPreviewSection extends StatelessWidget {
  const HomeServicesPreviewSection({
    super.key,
    required this.services,
    this.onSeeAll,
  });

  final List<HomeServicePreview> services;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return _CarouselSection(
      title: l10n.tabServices,
      subtitle: l10n.homeSectionServicesSubtitle,
      height: 148,
      itemCount: services.length,
      viewportFraction: 0.33,
      actionLabel: onSeeAll == null ? null : l10n.commonSeeAll,
      onActionPressed: onSeeAll,
      itemBuilder: (context, index) {
        final service = services[index];
        return _ServiceImageCard(
          service: service,
          onTap: () => context.push(AppRoutes.serviceById(service.id)),
        );
      },
    );
  }
}

class HomeOffersPreviewSection extends StatelessWidget {
  const HomeOffersPreviewSection({
    super.key,
    required this.offers,
    this.title,
    this.subtitle,
    this.layout = HomeOfferPreviewLayout.compact,
    this.onSeeAll,
  });

  final List<HomeOfferPreview> offers;

  /// Defaults to the localized "For You" / "Selected offers for today" when
  /// not overridden (Top Offers passes its own title/subtitle).
  final String? title;
  final String? subtitle;
  final HomeOfferPreviewLayout layout;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final isHero = layout == HomeOfferPreviewLayout.hero;

    return _CarouselSection(
      title: title ?? l10n.homeSectionForYouTitle,
      subtitle: subtitle ?? l10n.homeSectionForYouSubtitle,
      height: isHero ? 252 : 216,
      itemCount: offers.length,
      viewportFraction: isHero ? 1 : 0.6,
      actionLabel: onSeeAll == null ? null : l10n.commonSeeAll,
      onActionPressed: onSeeAll,
      itemBuilder: (context, index) {
        final offer = offers[index];

        void openOffer() {
          context.push(
            AppRoutes.homeItemDetail(offer.detailType.routeValue, offer.id),
          );
        }

        return isHero
            ? _TopOfferCard(offer: offer, onTap: openOffer)
            : _ForYouOfferCard(offer: offer, onTap: openOffer);
      },
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

class _CarouselSection extends StatefulWidget {
  const _CarouselSection({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.itemCount,
    required this.viewportFraction,
    required this.itemBuilder,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String subtitle;
  final double height;
  final int itemCount;
  final double viewportFraction;
  final IndexedWidgetBuilder itemBuilder;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          actionLabel: widget.actionLabel,
          onActionPressed: widget.onActionPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            padEnds: false,
            itemCount: widget.itemCount,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == widget.itemCount - 1 ? 0 : AppSpacing.md,
                ),
                child: widget.itemBuilder(context, index),
              );
            },
          ),
        ),
        if (widget.itemCount > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          _CarouselIndicator(
            count: widget.itemCount,
            activeIndex: _currentIndex,
          ),
        ],
      ],
    );
  }
}

class _TopOfferCard extends StatelessWidget {
  const _TopOfferCard({required this.offer, required this.onTap});

  final HomeOfferPreview offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ImageCardShell(
      imageUrl: offer.imageUrl,
      semanticLabel: offer.title,
      fallbackIcon: Icons.local_offer_rounded,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PillLabel(label: AppLocalizations.of(context).homeTopOfferBadge),
            const Spacer(),
            Text(
              offer.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // Over the dark image scrim in both themes.
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.dark.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (offer.subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                offer.subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                // Over the dark image scrim in both themes.
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.dark.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ForYouOfferCard extends StatelessWidget {
  const _ForYouOfferCard({required this.offer, required this.onTap});

  final HomeOfferPreview offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ImageCardShell(
      imageUrl: offer.imageUrl,
      semanticLabel: offer.title,
      fallbackIcon: Icons.auto_awesome_rounded,
      onTap: onTap,
      borderColor: AppColors.brandYellow.withValues(alpha: 0.64),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              offer.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.dark.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (offer.subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                offer.subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.dark.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServiceImageCard extends StatelessWidget {
  const _ServiceImageCard({required this.service, required this.onTap});

  final HomeServicePreview service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ImageCardShell(
      imageUrl: service.imageUrl,
      semanticLabel: service.title,
      fallbackIcon: Icons.campaign_rounded,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PillLabel(label: l10n.homeServiceBadge),
            const Spacer(),
            Text(
              service.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.dark.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              _joinNonEmpty([service.categoryName, service.location]) ??
                  l10n.homeServiceFallbackSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.dark.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageCardShell extends StatelessWidget {
  const _ImageCardShell({
    required this.imageUrl,
    required this.semanticLabel,
    required this.fallbackIcon,
    required this.onTap,
    required this.child,
    this.borderColor,
  });

  final String? imageUrl;
  final String semanticLabel;
  final IconData fallbackIcon;
  final VoidCallback onTap;
  final Widget child;

  /// Defaults to the theme's strong border when null.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          border: Border.all(color: borderColor ?? context.colors.borderStrong),
        ),
        child: Material(
          color: context.colors.cardSurface,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PromooImage(
                  imageUrl: imageUrl,
                  semanticLabel: semanticLabel,
                  fallbackIcon: fallbackIcon,
                ),
                const _CardImageOverlay(),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardImageOverlay extends StatelessWidget {
  const _CardImageOverlay();

  @override
  Widget build(BuildContext context) {
    // Constant dark scrim so white card text stays readable over photos in
    // both themes.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: [
            AppColors.brandBlack.withValues(alpha: 0.12),
            AppColors.brandBlack.withValues(alpha: 0.18),
            AppColors.brandBlack.withValues(alpha: 0.78),
          ],
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.brandYellow,
          borderRadius: AppRadius.pill,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.brandBlack,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: index == activeIndex ? 28 : 8,
            height: 8,
            margin: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: index == activeIndex
                  ? context.colors.accent
                  : context.colors.borderStrong,
              borderRadius: AppRadius.pill,
            ),
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
  });

  final String title;
  final String? subtitle;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.elevatedSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(fallbackIcon, color: context.colors.accent, size: 22),
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
