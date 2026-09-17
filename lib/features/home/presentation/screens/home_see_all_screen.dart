import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_controller.dart';

/// Full-list "See All" screen for a single Home section.
///
/// [section] is one of `offers` (Top Offers), `for_you`, `services`, or
/// `stories`. It reads the already-loaded [homeControllerProvider] content and
/// renders the complete list for that section. Phase A: local-only, sourced
/// from the mock home feed.
class HomeSeeAllScreen extends ConsumerWidget {
  const HomeSeeAllScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeControllerProvider);

    final Widget body;
    if (state.status == HomeStatus.loading) {
      body = Padding(
        padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
        child: PromooLoadingIndicator(message: l10n.commonLoading),
      );
    } else if (state.status == HomeStatus.error && state.content == null) {
      body = PromooErrorState(
        title: l10n.homeSeeAllErrorTitle,
        message: state.failure?.message ?? l10n.commonSomethingWentWrong,
        onRetry: () => ref.read(homeControllerProvider.notifier).retry(),
      );
    } else {
      body = _SeeAllBody(
        section: section,
        content: state.content ?? const HomeContent(),
      );
    }

    return PromooSubpageScaffold(
      title: _titleFor(l10n, section),
      scrollable: false,
      child: body,
    );
  }

  String _titleFor(AppLocalizations l10n, String section) {
    return switch (section) {
      'offers' => l10n.homeSectionTopOffersTitle,
      'for_you' => l10n.homeSectionForYouTitle,
      'services' => l10n.tabServices,
      'stories' => l10n.homeSectionStoriesTitle,
      _ => l10n.homeSeeAllTitleBrowse,
    };
  }
}

class _SeeAllBody extends StatelessWidget {
  const _SeeAllBody({required this.section, required this.content});

  final String section;
  final HomeContent content;

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards(context);
    if (cards.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return PromooEmptyState(
        title: l10n.homeSeeAllEmptyTitle,
        message: l10n.homeSeeAllEmptyMessage,
      );
    }

    return ListView.separated(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
      itemCount: cards.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => cards[index],
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    switch (section) {
      case 'services':
        return [
          for (final service in content.services)
            _SeeAllCard(
              key: ValueKey('service-${service.id}'),
              title: service.title,
              subtitle: _serviceSubtitle(service),
              imageUrl: service.imageUrl,
              fallbackIcon: Icons.campaign_rounded,
              onTap: () => context.push(AppRoutes.serviceById(service.id)),
            ),
        ];
      case 'stories':
        return [
          for (final story in content.stories)
            _SeeAllCard(
              key: ValueKey('story-${story.id}'),
              title: story.title,
              subtitle: story.profileName,
              imageUrl: story.imageUrl ?? story.profileAvatarUrl,
              fallbackIcon: Icons.play_circle_outline_rounded,
            ),
        ];
      case 'for_you':
        final forYou = content.offers.skip(5).toList(growable: false);
        return _offerCards(
          context,
          forYou.isNotEmpty ? forYou : content.offers,
        );
      case 'offers':
      default:
        return _offerCards(context, content.offers);
    }
  }

  List<Widget> _offerCards(
    BuildContext context,
    List<HomeOfferPreview> offers,
  ) {
    return [
      for (final offer in offers)
        _SeeAllCard(
          key: ValueKey('offer-${offer.id}'),
          title: offer.title,
          subtitle: offer.subtitle,
          imageUrl: offer.imageUrl,
          fallbackIcon: Icons.local_offer_rounded,
          onTap: () => context.push(
            AppRoutes.homeItemDetail(offer.detailType.routeValue, offer.id),
          ),
        ),
    ];
  }

  String? _serviceSubtitle(HomeServicePreview service) {
    final parts = <String>[
      if (service.categoryName != null &&
          service.categoryName!.trim().isNotEmpty)
        service.categoryName!,
      if (service.location != null && service.location!.trim().isNotEmpty)
        service.location!,
    ];
    if (parts.isEmpty) {
      return service.subtitle;
    }
    return parts.join(' • ');
  }
}

class _SeeAllCard extends StatelessWidget {
  const _SeeAllCard({
    super.key,
    required this.title,
    required this.fallbackIcon,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final IconData fallbackIcon;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: AppRadius.card,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.input,
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: PromooImage(
                    imageUrl: imageUrl,
                    semanticLabel: title,
                    fallbackIcon: fallbackIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (hasSubtitle) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.chevron_right_rounded, color: colors.textMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
