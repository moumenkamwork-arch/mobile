import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_spacing.dart';
import '../../../ads/domain/entities/ad_listing.dart';
import '../../../offers/domain/entities/offer_listing.dart';
import '../../../profile/presentation/screens/add_ad_wizard_screen.dart';
import '../../../profile/presentation/screens/add_offer_screen.dart';
import '../../../profile/presentation/screens/add_service_screen.dart';
import '../../../services/domain/entities/promoo_service.dart';
import '../controllers/my_listings_controller.dart';

/// "My Listings" — the signed-in user's own offers/services/ads (every
/// status, not just active), with edit (reuses the Add screens pre-filled)
/// and delete. Feeds from `GET /offers|/services|/ads/profile/:myId`.
class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fresh ProviderScope per visit — same reasoning as FollowingScreen/
    // SavedItemsScreen (root-scoped Notifier only loads once in `build()`).
    return ProviderScope(
      overrides: [
        myListingsControllerProvider.overrideWith(MyListingsController.new),
      ],
      child: const _MyListingsScreenBody(),
    );
  }
}

class _MyListingsScreenBody extends ConsumerWidget {
  const _MyListingsScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(myListingsControllerProvider);

    return PromooSubpageScaffold(
      title: l10n.menuMyListings,
      child: switch (state.status) {
        MyListingsStatus.loading => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooLoadingIndicator(message: l10n.menuMyListings),
        ),
        MyListingsStatus.error => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooErrorState(
            title: l10n.commonSomethingWentWrong,
            message: state.failure?.message ?? l10n.commonSomethingWentWrong,
            onRetry: () =>
                ref.read(myListingsControllerProvider.notifier).retry(),
          ),
        ),
        MyListingsStatus.empty => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooEmptyState(
            title: l10n.myListingsEmptyTitle,
            message: l10n.myListingsEmptyMessage,
          ),
        ),
        MyListingsStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.offers.isNotEmpty) ...[
              _SectionHeader(l10n.myListingsOffersSection),
              for (final offer in state.offers) ...[
                _OfferRow(offer: offer),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
            if (state.services.isNotEmpty) ...[
              _SectionHeader(l10n.myListingsServicesSection),
              for (final service in state.services) ...[
                _ServiceRow(service: service),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
            if (state.ads.isNotEmpty) ...[
              _SectionHeader(l10n.myListingsAdsSection),
              for (final ad in state.ads) ...[
                _AdRow(ad: ad),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],
        ),
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

/// Confirms, then calls [onDelete]; shows a failure snackbar if it returns
/// `false` (the controller already reverted its optimistic removal).
Future<void> _confirmAndDelete(
  BuildContext context,
  Future<bool> Function() onDelete,
) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.myListingsDeleteConfirmTitle),
      content: Text(l10n.myListingsDeleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            l10n.myListingsDeleteConfirmButton,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) {
    return;
  }

  final succeeded = await onDelete();
  if (!context.mounted || succeeded) {
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l10n.myListingsDeleteFailed)));
}

class _ListingActions extends StatelessWidget {
  const _ListingActions({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.myListingsEditTooltip,
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: l10n.myListingsDeleteTooltip,
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
        ),
      ],
    );
  }
}

class _OfferRow extends ConsumerWidget {
  const _OfferRow({required this.offer});

  final OfferListing offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: PromooImage(imageUrl: offer.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  '${offer.offerPrice} · ${offer.status}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _ListingActions(
            onEdit: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddOfferScreen(editing: offer),
              ),
            ),
            onDelete: () => _confirmAndDelete(
              context,
              () => ref
                  .read(myListingsControllerProvider.notifier)
                  .deleteOffer(offer.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends ConsumerWidget {
  const _ServiceRow({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceLabel = service.price?.label ?? '';
    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: PromooImage(
                imageUrl: service.imageUrls.isEmpty
                    ? null
                    : service.imageUrls.first,
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
                  service.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  [
                    if (priceLabel.isNotEmpty) priceLabel,
                    if (service.status != null) service.status!,
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _ListingActions(
            onEdit: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddServiceScreen(editing: service),
              ),
            ),
            onDelete: () => _confirmAndDelete(
              context,
              () => ref
                  .read(myListingsControllerProvider.notifier)
                  .deleteService(service.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdRow extends ConsumerWidget {
  const _AdRow({required this.ad});

  final AdListing ad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PromooCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: PromooImage(imageUrl: ad.mediaUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  ad.status,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _ListingActions(
            onEdit: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddAdWizardScreen(editing: ad),
              ),
            ),
            onDelete: () => _confirmAndDelete(
              context,
              () =>
                  ref.read(myListingsControllerProvider.notifier).deleteAd(ad.id),
            ),
          ),
        ],
      ),
    );
  }
}
