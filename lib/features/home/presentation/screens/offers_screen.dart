import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_controller.dart';

/// Top-level **Offers** tab — the bottom-nav slot shown to everyone EXCEPT
/// influencers (who see the Influencer/Seats tab in that slot instead; the
/// Seats screen is influencer-only per client request 2026-07-14).
///
/// A full-screen browsable list of the current offers, sourced from the same
/// home feed (`homeControllerProvider`) that powers the Home "Top Offers" /
/// "For You" sections. Tapping an offer opens its detail.
class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooPageHeader(applyTopSafeArea: true),
        Expanded(child: _body(context, ref, state)),
      ],
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, HomeState state) {
    final l10n = AppLocalizations.of(context);

    if (state.status == HomeStatus.loading && state.content == null) {
      return Center(child: PromooLoadingIndicator(message: l10n.commonLoading));
    }
    if (state.status == HomeStatus.error && state.content == null) {
      return Center(
        child: PromooErrorState(
          title: l10n.homeSeeAllErrorTitle,
          message: state.failure?.message ?? l10n.commonSomethingWentWrong,
          onRetry: () => ref.read(homeControllerProvider.notifier).retry(),
        ),
      );
    }

    final offers = state.content?.offers ?? const <HomeOfferPreview>[];
    if (offers.isEmpty) {
      return PromooEmptyState(
        title: l10n.homeSeeAllEmptyTitle,
        message: l10n.homeSeeAllEmptyMessage,
      );
    }

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        AppSpacing.shellScrollBottom,
      ),
      itemCount: offers.length + 1,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return PromooSectionHeader(
            title: l10n.homeSectionTopOffersTitle,
            subtitle: l10n.homeSectionForYouSubtitle,
          );
        }
        final offer = offers[index - 1];
        return _OfferListCard(
          offer: offer,
          onTap: () => context.push(
            AppRoutes.homeItemDetail(offer.detailType.routeValue, offer.id),
          ),
        );
      },
    );
  }
}

class _OfferListCard extends StatelessWidget {
  const _OfferListCard({required this.offer, required this.onTap});

  final HomeOfferPreview offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasSubtitle =
        offer.subtitle != null && offer.subtitle!.trim().isNotEmpty;

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
                    imageUrl: offer.imageUrl,
                    semanticLabel: offer.title,
                    fallbackIcon: Icons.local_offer_rounded,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (hasSubtitle) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        offer.subtitle!,
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
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right_rounded, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
