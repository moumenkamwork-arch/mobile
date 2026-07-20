import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

class SeatCheckoutPreviewScreen extends StatelessWidget {
  const SeatCheckoutPreviewScreen({
    super.key,
    required this.seatId,
    required this.title,
    required this.tierLabel,
    required this.priceLabel,
  });

  final String seatId;
  final String title;
  final String tierLabel;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final displayTitle = title.trim().isEmpty
        ? l10n.seatsCheckoutFallbackTitle
        : title;
    final displayTier = tierLabel.trim().isEmpty
        ? l10n.seatsCheckoutFallbackTier
        : tierLabel;
    final displayPrice = priceLabel.trim().isEmpty
        ? l10n.seatsCheckoutFallbackPrice
        : priceLabel;

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
              Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: l10n.seatsCheckoutBackTooltip,
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.seats);
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.seatsCheckoutTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          l10n.seatsCheckoutSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              PromooCard(
                elevated: true,
                borderColor: colors.primaryYellow,
                color: colors.elevatedSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.primaryYellow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.event_seat_rounded,
                            color: AppColors.brandBlack,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.xxxs),
                              Text(
                                displayTier,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SummaryRow(
                      label: l10n.seatsCheckoutSeatIdLabel,
                      value: seatId,
                    ),
                    _SummaryRow(
                      label: l10n.seatsCheckoutPlacementLabel,
                      value: displayTier,
                    ),
                    _SummaryRow(
                      label: l10n.seatsCheckoutAmountLabel,
                      value: displayPrice,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PromooCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.seatsCheckoutPaymentDetailsTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PromooTextField(
                      label: l10n.seatsCheckoutCardholderName,
                      hint: l10n.seatsCheckoutNameOnCard,
                      prefixIcon: const Icon(Icons.person_rounded),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PromooTextField(
                      label: l10n.seatsCheckoutCardNumber,
                      hint: '0000 0000 0000 0000',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.credit_card_rounded),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: PromooTextField(
                            label: l10n.seatsCheckoutExpiry,
                            hint: 'MM / YY',
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: PromooTextField(
                            label: l10n.seatsCheckoutCvv,
                            hint: '123',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PromooButton.primary(
                      label: l10n.seatsCheckoutPreviewPayment,
                      icon: Icons.lock_rounded,
                      fullWidth: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.seatsCheckoutPreviewOnlyNotice,
                              ),
                            ),
                          );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.seatsCheckoutNextPhaseNotice,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
