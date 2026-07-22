import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_avatar_circle.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_detail_chip.dart';
import '../../../../shared/widgets/promoo_detail_header.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_inline_notice.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_metric.dart';
import '../../../reports/domain/entities/report_draft.dart';
import '../../../reports/presentation/report_menu_button.dart';
import '../../../../shared/widgets/promoo_save_button.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_service.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: _ServiceDetailBody(serviceId: serviceId),
      ),
    );
  }
}

class _ServiceDetailBody extends ConsumerStatefulWidget {
  const _ServiceDetailBody({required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<_ServiceDetailBody> createState() => _ServiceDetailBodyState();
}

class _ServiceDetailBodyState extends ConsumerState<_ServiceDetailBody> {
  var _showContactNotice = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(serviceDetailControllerProvider(widget.serviceId));

    return switch (state.status) {
      ServiceDetailStatus.loading => PromooLoadingIndicator(
        message: l10n.serviceDetailLoadingMessage,
      ),
      ServiceDetailStatus.error => PromooErrorState(
        title: l10n.serviceDetailErrorTitle,
        message: state.failure?.message ?? l10n.commonSomethingWentWrong,
        onRetry: () => ref
            .read(serviceDetailControllerProvider(widget.serviceId).notifier)
            .retry(),
      ),
      ServiceDetailStatus.success => _ServiceDetailContent(
        service: state.service!,
        showContactNotice: _showContactNotice,
        onBack: () => _goBack(context),
        onContactPressed: () {
          setState(() => _showContactNotice = true);
        },
        // Push keeps the stack intact so back returns to these details.
        onOpenChatsPressed: () => context.push(AppRoutes.chats),
        onViewProfilePressed: state.service!.provider == null
            ? null
            : () => context.push(
                AppRoutes.profileById(state.service!.provider!.id),
              ),
        onDismissContactNotice: () {
          setState(() => _showContactNotice = false);
        },
      ),
    };
  }
}

class _ServiceDetailContent extends StatelessWidget {
  const _ServiceDetailContent({
    required this.service,
    required this.showContactNotice,
    required this.onBack,
    required this.onContactPressed,
    required this.onOpenChatsPressed,
    required this.onDismissContactNotice,
    this.onViewProfilePressed,
  });

  final PromooService service;
  final bool showContactNotice;
  final VoidCallback onBack;
  final VoidCallback onContactPressed;
  final VoidCallback onOpenChatsPressed;
  final VoidCallback? onViewProfilePressed;
  final VoidCallback onDismissContactNotice;

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
              PromooDetailHeader(
                title: AppLocalizations.of(context).serviceDetailScreenTitle,
                onBack: onBack,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PromooSaveButton(
                      itemId: service.id,
                      itemType: 'service',
                      title: service.title,
                      subtitle: service.category?.name,
                      imageUrl: service.imageUrls.isEmpty
                          ? null
                          : service.imageUrls.first,
                    ),
                    PromooReportMenuButton(
                      reportedId: service.id,
                      reportedType: ReportedType.service,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _HeroCard(service: service),
              const SizedBox(height: AppSpacing.lg),
              _ServiceSummary(service: service),
              if (service.description != null &&
                  service.description!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _DescriptionSection(description: service.description!),
              ],
              if (service.deliveryDays != null || service.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _DeliveryTagsSection(service: service),
              ],
              const SizedBox(height: AppSpacing.lg),
              _ProviderSummary(provider: service.provider),
              const SizedBox(height: AppSpacing.lg),
              _ContactSection(
                showNotice: showContactNotice,
                hasProfile: onViewProfilePressed != null,
                onContactPressed: onContactPressed,
                onOpenChatsPressed: onOpenChatsPressed,
                onViewProfilePressed: onViewProfilePressed,
                onDismissNotice: onDismissContactNotice,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.imageUrls.isEmpty ? null : service.imageUrls.first;

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
                imageUrl: imageUrl,
                semanticLabel: service.title,
                fallbackIcon: Icons.storefront_rounded,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (service.category != null)
                      PromooDetailChip(
                        icon: Icons.category_rounded,
                        label: service.category!.name,
                      ),
                    if (service.provider != null)
                      PromooDetailChip(
                        icon: service.provider!.isVerified
                            ? Icons.verified_rounded
                            : Icons.person_rounded,
                        label: service.provider!.name,
                      ),
                    if (service.location != null)
                      PromooDetailChip(
                        icon: Icons.place_outlined,
                        label: service.location!,
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

class _ServiceSummary extends StatelessWidget {
  const _ServiceSummary({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooCard(
      child: Row(
        children: [
          Expanded(
            child: PromooMetric(
              label: l10n.commonPrice,
              value: service.price?.label ?? l10n.commonContactForPricing,
              icon: Icons.sell_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: PromooMetric(
              label: l10n.serviceDetailTimelineLabel,
              value: service.deliveryDays == null
                  ? l10n.serviceDetailDiscussWithProvider
                  : l10n.serviceDetailDaysCount(service.deliveryDays!),
              icon: Icons.schedule_rounded,
            ),
          ),
        ],
      ),
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

class _DeliveryTagsSection extends StatelessWidget {
  const _DeliveryTagsSection({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: l10n.commonDetails,
          subtitle: l10n.serviceDetailTagsSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (service.deliveryDays != null)
                PromooDetailChip(
                  icon: Icons.schedule_rounded,
                  label: l10n.servicesDeliveryDaysLabel(service.deliveryDays!),
                ),
              for (final tag in service.tags) PromooDetailChip(label: tag),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider});

  final ServiceProvider? provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = provider;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(title: l10n.commonProvider),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: current == null
              ? Row(
                  children: [
                    PromooAvatarCircle(
                      imageUrl: null,
                      semanticLabel: l10n.serviceDetailProviderFallbackSemantic,
                      fallbackIcon: Icons.storefront_rounded,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.serviceDetailProviderPending,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    PromooAvatarCircle(
                      imageUrl: current.avatarUrl,
                      semanticLabel: current.name,
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
                                  current.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              if (current.isVerified) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Icon(
                                  Icons.verified_rounded,
                                  color: context.colors.accent,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                          if (current.username != null) ...[
                            const SizedBox(height: AppSpacing.xxxs),
                            Text(
                              '@${current.username}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          if (current.accountType != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            PromooDetailChip(
                              label: _labelFor(current.accountType!),
                            ),
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

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.showNotice,
    required this.hasProfile,
    required this.onContactPressed,
    required this.onOpenChatsPressed,
    required this.onDismissNotice,
    this.onViewProfilePressed,
  });

  final bool showNotice;
  final bool hasProfile;
  final VoidCallback onContactPressed;
  final VoidCallback onOpenChatsPressed;
  final VoidCallback? onViewProfilePressed;
  final VoidCallback onDismissNotice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromooSectionHeader(
          title: l10n.homeDetailContact,
          subtitle: l10n.serviceDetailContactSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (showNotice) ...[
          PromooInlineNotice(
            message: l10n.commonContactFlowComingSoon,
            onDismiss: onDismissNotice,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PromooButton.primary(
          label: l10n.serviceDetailContactProvider,
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
      ],
    );
  }
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
    context.go(AppRoutes.services);
  }
}
