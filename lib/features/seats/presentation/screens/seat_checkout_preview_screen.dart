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
    final displayTitle = title.trim().isEmpty ? 'Influencer Seat' : title;
    final displayTier = tierLabel.trim().isEmpty
        ? 'Visibility seat'
        : tierLabel;
    final displayPrice = priceLabel.trim().isEmpty
        ? 'Price shown after seat selection'
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
                    tooltip: 'Back to seats',
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
                          'Checkout preview',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          'Confirm the placement before payment is enabled.',
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
                    _SummaryRow(label: 'Seat ID', value: seatId),
                    _SummaryRow(label: 'Placement', value: displayTier),
                    _SummaryRow(label: 'Amount', value: displayPrice),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PromooCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const PromooTextField(
                      label: 'Cardholder name',
                      hint: 'Name on card',
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const PromooTextField(
                      label: 'Card number',
                      hint: '0000 0000 0000 0000',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.credit_card_rounded),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: const [
                        Expanded(
                          child: PromooTextField(
                            label: 'Expiry',
                            hint: 'MM / YY',
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: PromooTextField(
                            label: 'CVV',
                            hint: '123',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PromooButton.primary(
                      label: 'Preview payment',
                      icon: Icons.lock_rounded,
                      fullWidth: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Checkout preview only. No payment was processed.',
                              ),
                            ),
                          );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Booking and payment open in the next phase.',
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
