import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/home_content.dart';
import '../controllers/home_content_detail_controller.dart';

/// Resolves the localized label for a [HomeContentDetailType]. A free
/// function (not a domain-entity getter) because domain code must stay
/// Flutter-free.
String homeContentDetailTypeLabel(
  BuildContext context,
  HomeContentDetailType type,
) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    HomeContentDetailType.offer => l10n.homeDetailTypeOffer,
    HomeContentDetailType.ad => l10n.homeDetailTypeAd,
    HomeContentDetailType.unknown => l10n.homeDetailTypeUnknown,
  };
}

class HomeContentDetailScreen extends StatelessWidget {
  const HomeContentDetailScreen({
    super.key,
    required this.type,
    required this.itemId,
  });

  final String type;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: _HomeContentDetailBody(
          request: HomeContentDetailRequest(
            type: HomeContentDetailTypeValue.fromRouteValue(type),
            id: itemId,
          ),
        ),
      ),
    );
  }
}

class _HomeContentDetailBody extends ConsumerStatefulWidget {
  const _HomeContentDetailBody({required this.request});

  final HomeContentDetailRequest request;

  @override
  ConsumerState<_HomeContentDetailBody> createState() =>
      _HomeContentDetailBodyState();
}

class _HomeContentDetailBodyState
    extends ConsumerState<_HomeContentDetailBody> {
  String? _noticeMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(
      homeContentDetailControllerProvider(widget.request),
    );

    return switch (state.status) {
      HomeContentDetailStatus.loading => PromooLoadingIndicator(
        message: l10n.homeDetailLoadingMessage,
      ),
      HomeContentDetailStatus.error => PromooErrorState(
        title: l10n.homeDetailErrorTitle,
        message: state.failure?.message ?? l10n.commonSomethingWentWrong,
        onRetry: () => ref
            .read(homeContentDetailControllerProvider(widget.request).notifier)
            .retry(),
      ),
      HomeContentDetailStatus.success => _HomeContentDetailContent(
        detail: state.detail!,
        noticeMessage: _noticeMessage,
        onBack: () => _goBack(context),
        onContactPressed: () {
          setState(() {
            _noticeMessage = l10n.commonContactFlowComingSoon;
          });
        },
        // Push keeps the stack intact so back returns to these details.
        onOpenChatsPressed: () => context.push(AppRoutes.chats),
        onLocationPressed: state.detail!.location == null
            ? null
            : () {
                setState(() {
                  _noticeMessage = l10n.homeDetailLocationComingSoon(
                    state.detail!.location!,
                  );
                });
              },
        onViewProfilePressed: state.detail!.provider == null
            ? null
            : () => context.push(
                AppRoutes.profileById(state.detail!.provider!.id),
              ),
        onDismissNotice: () {
          setState(() => _noticeMessage = null);
        },
      ),
    };
  }
}

class _HomeContentDetailContent extends StatelessWidget {
  const _HomeContentDetailContent({
    required this.detail,
    required this.onBack,
    required this.onContactPressed,
    required this.onOpenChatsPressed,
    required this.onDismissNotice,
    this.noticeMessage,
    this.onLocationPressed,
    this.onViewProfilePressed,
  });

  final HomeContentDetail detail;
  final String? noticeMessage;
  final VoidCallback onBack;
  final VoidCallback onContactPressed;
  final VoidCallback onOpenChatsPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onViewProfilePressed;
  final VoidCallback onDismissNotice;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screenHorizontal,
            AppSpacing.screenVertical,
            AppSpacing.screenHorizontal,
            AppSpacing.shellScrollBottom,
          ),
          sliver: SliverList.list(
            children: [
              _DetailHeader(
                title: homeContentDetailTypeLabel(context, detail.type),
                onBack: onBack,
              ),
              const SizedBox(height: AppSpacing.lg),
              _HeroCard(detail: detail),
              const SizedBox(height: AppSpacing.lg),
              _SummaryCard(detail: detail),
              if (detail.description != null &&
                  detail.description!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _DescriptionSection(description: detail.description!),
              ],
              if (detail.provider != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _ProviderSection(provider: detail.provider!),
              ],
              if (detail.hasDetails) ...[
                const SizedBox(height: AppSpacing.lg),
                _DetailsSection(detail: detail),
              ],
              const SizedBox(height: AppSpacing.lg),
              _ActionSection(
                noticeMessage: noticeMessage,
                hasProfile: onViewProfilePressed != null,
                hasLocation: onLocationPressed != null,
                onContactPressed: onContactPressed,
                onOpenChatsPressed: onOpenChatsPressed,
                onLocationPressed: onLocationPressed,
                onViewProfilePressed: onViewProfilePressed,
                onDismissNotice: onDismissNotice,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context).commonBack,
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.detail});

  final HomeContentDetail detail;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      elevated: true,
      padding: EdgeInsets.zero,
      borderColor: context.colors.borderStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: PromooImage(
                imageUrl: detail.imageUrl,
                semanticLabel: detail.title,
                fallbackIcon: _iconFor(detail.type),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailChip(
                  icon: detail.type == HomeContentDetailType.ad
                      ? Icons.campaign_rounded
                      : Icons.local_offer_rounded,
                  label:
                      detail.badge ??
                      homeContentDetailTypeLabel(context, detail.type),
                  highlighted: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  detail.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (detail.categoryName != null)
                      _DetailChip(
                        icon: Icons.category_rounded,
                        label: detail.categoryName!,
                      ),
                    if (detail.provider != null)
                      _DetailChip(
                        icon: detail.provider!.isVerified
                            ? Icons.verified_rounded
                            : Icons.person_rounded,
                        label: detail.provider!.displayName,
                      ),
                    if (detail.location != null)
                      _DetailChip(
                        icon: Icons.place_outlined,
                        label: detail.location!,
                      ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.detail});

  final HomeContentDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooCard(
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              icon: Icons.sell_outlined,
              label: l10n.commonPrice,
              value: detail.price?.label ?? l10n.commonContactForPricing,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _SummaryMetric(
              icon: Icons.schedule_rounded,
              label: l10n.homeDetailAvailabilityLabel,
              value: detail.validUntil ?? l10n.homeDetailAvailabilityFallback,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: context.colors.accent, size: 20),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: AppSpacing.xxxs),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: AppLocalizations.of(context).commonDescription,
        ),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _ProviderSection extends StatelessWidget {
  const _ProviderSection({required this.provider});

  final HomeContentProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(title: AppLocalizations.of(context).commonProvider),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.colors.elevatedSurface,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: PromooImage(
                    imageUrl: provider.avatarUrl,
                    semanticLabel: provider.displayName,
                    fallbackIcon: Icons.person_rounded,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            provider.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (provider.isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.verified_rounded,
                            color: context.colors.accent,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    if (provider.username != null) ...[
                      const SizedBox(height: AppSpacing.xxxs),
                      Text(
                        '@${provider.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (provider.accountType != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _DetailChip(label: _labelFor(provider.accountType!)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.detail});

  final HomeContentDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(title: AppLocalizations.of(context).commonDetails),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  if (detail.location != null)
                    _DetailChip(
                      icon: Icons.place_outlined,
                      label: detail.location!,
                    ),
                  if (detail.promoCode != null)
                    _DetailChip(
                      icon: Icons.confirmation_number_outlined,
                      label: detail.promoCode!,
                    ),
                  if (detail.validUntil != null)
                    _DetailChip(
                      icon: Icons.event_available_rounded,
                      label: detail.validUntil!,
                    ),
                  for (final tag in detail.tags) _DetailChip(label: tag),
                ],
              ),
              if (detail.terms != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  detail.terms!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.hasProfile,
    required this.hasLocation,
    required this.onContactPressed,
    required this.onOpenChatsPressed,
    required this.onDismissNotice,
    this.noticeMessage,
    this.onLocationPressed,
    this.onViewProfilePressed,
  });

  final String? noticeMessage;
  final bool hasProfile;
  final bool hasLocation;
  final VoidCallback onContactPressed;
  final VoidCallback onOpenChatsPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onViewProfilePressed;
  final VoidCallback onDismissNotice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: l10n.homeDetailNextStepTitle,
          subtitle: l10n.homeDetailNextStepSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (noticeMessage != null) ...[
          PromooCard(
            borderColor: context.colors.accent,
            color: context.colors.elevatedSurface,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: context.colors.accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    noticeMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonDismiss,
                  onPressed: onDismissNotice,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PromooButton.primary(
          label: l10n.homeDetailContact,
          icon: Icons.phone_in_talk_rounded,
          fullWidth: true,
          onPressed: onContactPressed,
        ),
        const SizedBox(height: AppSpacing.sm),
        PromooButton.secondary(
          label: l10n.commonOpenChats,
          icon: Icons.chat_bubble_outline_rounded,
          fullWidth: true,
          onPressed: onOpenChatsPressed,
        ),
        if (hasProfile) ...[
          const SizedBox(height: AppSpacing.sm),
          PromooButton.tertiary(
            label: l10n.commonViewProviderProfile,
            icon: Icons.person_rounded,
            fullWidth: true,
            onPressed: onViewProfilePressed,
          ),
        ],
        if (hasLocation) ...[
          const SizedBox(height: AppSpacing.sm),
          PromooButton.tertiary(
            label: l10n.homeDetailLocation,
            icon: Icons.place_outlined,
            fullWidth: true,
            onPressed: onLocationPressed,
          ),
        ],
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, this.icon, this.highlighted = false});

  final String label;
  final IconData? icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = highlighted ? AppColors.brandBlack : colors.textPrimary;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: highlighted ? colors.primaryYellow : colors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: highlighted ? colors.primaryYellow : colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: highlighted ? AppColors.brandBlack : colors.accent,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: highlighted ? FontWeight.w800 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(HomeContentDetailType type) {
  return switch (type) {
    HomeContentDetailType.offer => Icons.local_offer_rounded,
    HomeContentDetailType.ad => Icons.campaign_rounded,
    HomeContentDetailType.unknown => Icons.auto_awesome_rounded,
  };
}

String _labelFor(String value) {
  return value
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}
