import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
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
    return _ServiceDetailBody(serviceId: serviceId);
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
    final state = ref.watch(serviceDetailControllerProvider(widget.serviceId));

    return switch (state.status) {
      ServiceDetailStatus.loading => const PromooLoadingIndicator(
        message: 'Loading service details',
      ),
      ServiceDetailStatus.error => PromooErrorState(
        title: 'Could not load service',
        message: state.failure?.message ?? 'Something went wrong.',
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
        onOpenChatsPressed: () => context.go(AppRoutes.chats),
        onViewProfilePressed: state.service!.provider == null
            ? null
            : () => context.go(
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
              _DetailHeader(onBack: onBack),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Service details',
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
  const _HeroCard({required this.service});

  final PromooService service;

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.imageUrls.isEmpty ? null : service.imageUrls.first;

    return PromooCard(
      elevated: true,
      padding: EdgeInsets.zero,
      borderColor: AppColors.borderStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: const BorderRadiusDirectional.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
              image: imageUrl == null
                  ? null
                  : DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
            ),
            child: imageUrl == null
                ? const Center(
                    child: Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primaryYellow,
                      size: 52,
                    ),
                  )
                : null,
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
                      _DetailChip(
                        icon: Icons.category_rounded,
                        label: service.category!.name,
                      ),
                    if (service.provider != null)
                      _DetailChip(
                        icon: service.provider!.isVerified
                            ? Icons.verified_rounded
                            : Icons.person_rounded,
                        label: service.provider!.name,
                      ),
                    if (service.location != null)
                      _DetailChip(
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
    return PromooCard(
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Price',
              value: service.price?.label ?? 'Contact for pricing',
              icon: Icons.sell_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _SummaryMetric(
              label: 'Timeline',
              value: service.deliveryDays == null
                  ? 'Discuss with provider'
                  : '${service.deliveryDays} days',
              icon: Icons.schedule_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryYellow, size: 20),
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
        const PromooSectionHeader(title: 'Description'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooSectionHeader(
          title: 'Details',
          subtitle: 'Useful signals before contacting the provider',
        ),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (service.deliveryDays != null)
                _DetailChip(
                  icon: Icons.schedule_rounded,
                  label: '${service.deliveryDays} day delivery',
                ),
              for (final tag in service.tags) _DetailChip(label: tag),
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
    final current = provider;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooSectionHeader(title: 'Provider'),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: current == null
              ? Row(
                  children: [
                    _ProviderAvatar(provider: null),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Provider details will appear when available.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _ProviderAvatar(provider: current),
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
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.primaryYellow,
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
                            _DetailChip(label: _labelFor(current.accountType!)),
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

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.provider});

  final ServiceProvider? provider;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = provider?.avatarUrl;
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.elevatedSurface,
      backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
      child: avatarUrl == null
          ? Icon(
              provider == null
                  ? Icons.storefront_rounded
                  : Icons.person_rounded,
              color: AppColors.primaryYellow,
            )
          : null,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooSectionHeader(
          title: 'Contact',
          subtitle: 'Connect with the provider before taking the next step',
        ),
        const SizedBox(height: AppSpacing.md),
        if (showNotice) ...[
          PromooCard(
            borderColor: AppColors.primaryYellow,
            color: AppColors.elevatedSurface,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryYellow,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Contact flow coming soon. You can open chats or view the provider profile.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: onDismissNotice,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PromooButton.primary(
          label: 'Contact provider',
          icon: Icons.phone_in_talk_rounded,
          fullWidth: true,
          onPressed: onContactPressed,
        ),
        const SizedBox(height: AppSpacing.sm),
        PromooButton.secondary(
          label: 'Open chats',
          icon: Icons.chat_bubble_outline_rounded,
          fullWidth: true,
          onPressed: onOpenChatsPressed,
        ),
        if (hasProfile) ...[
          const SizedBox(height: AppSpacing.sm),
          PromooButton.tertiary(
            label: 'View provider profile',
            icon: Icons.person_rounded,
            fullWidth: true,
            onPressed: onViewProfilePressed,
          ),
        ],
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primaryYellow, size: 14),
            const SizedBox(width: AppSpacing.xxs),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
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
