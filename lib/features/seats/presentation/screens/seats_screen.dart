import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_page_header.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/seat.dart';
import '../controllers/seats_controller.dart';

/// Maps a [SeatTier] to the ICU `select` key used by the `seats*Label`
/// messages (`seatsLegendLabel`/`seatsSingularLabel`/
/// `seatsVisibilityPlacementLabel`). Kept as a `select` (not naive string
/// concatenation) because adjective+noun order differs by language — Arabic
/// "Gold Seat" is "مقعد ذهبي" (noun first), not a tier word glued onto "Seat".
String _seatTierKey(SeatTier tier) => tier.apiValue ?? 'unknown';

/// Influencer page recreating the original app: search bar, tier legend,
/// and a large seat grid that overflows the screen in BOTH directions.
///
/// Tier zones follow the original layout: Gold seats sit in the top-left
/// block, Silver surrounds them, Bronze fills the outer band — so scrolling
/// down OR right always moves Gold → Silver → Bronze.
class SeatsScreen extends ConsumerStatefulWidget {
  const SeatsScreen({super.key});

  @override
  ConsumerState<SeatsScreen> createState() => _SeatsScreenState();
}

class _SeatsScreenState extends ConsumerState<SeatsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(seatsControllerProvider);

    // The header paints its own status-bar inset so the black chrome band
    // reaches the top edge in both themes (no paper seam in light mode).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromooPageHeader(applyTopSafeArea: true),
        const SizedBox(height: AppSpacing.sm),
        _StatsStrip(seats: state.seats),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: PromooTextField(
            controller: _searchController,
            hint: l10n.seatsSearchHint,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.colors.accent,
              size: 26,
            ),
            onChanged: (value) => setState(() => _query = value.trim()),
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screenHorizontal,
            AppSpacing.md,
            AppSpacing.screenHorizontal,
            AppSpacing.sm,
          ),
          child: _SeatLegend(),
        ),
        Expanded(child: _buildBody(state)),
      ],
    );
  }

  Widget _buildBody(SeatsState state) {
    final l10n = AppLocalizations.of(context);
    switch (state.status) {
      case SeatsStatus.loading:
        return Center(
          child: PromooLoadingIndicator(message: l10n.seatsLoadingMessage),
        );
      case SeatsStatus.error when !state.hasContent:
        return Center(
          child: PromooErrorState(
            title: l10n.seatsErrorTitle,
            message: state.failure?.message ?? l10n.seatsErrorFallback,
            onRetry: () => ref.read(seatsControllerProvider.notifier).retry(),
          ),
        );
      case SeatsStatus.empty:
        return Center(
          child: PromooErrorState(
            title: l10n.seatsEmptyTitle,
            message: l10n.seatsEmptyMessage,
            onRetry: () => ref.read(seatsControllerProvider.notifier).retry(),
          ),
        );
      default:
        return _SeatGrid(seats: state.seats, query: _query);
    }
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.seats});

  final List<Seat> seats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final influencers = seats.where((s) => s.holder != null).length;
    final available = seats.where((s) => s.isAvailable).length;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              icon: Icons.people_alt_rounded,
              value: '$influencers',
              label: l10n.seatsStatsInfluencers,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _StatChip(
              icon: Icons.event_seat_rounded,
              value: '$available',
              label: l10n.seatsStatsAvailable,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.accent, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatLegend extends StatelessWidget {
  const _SeatLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LegendItem(
          color: context.colors.primaryYellow,
          label: l10n.seatsLegendLabel('gold'),
        ),
        _LegendItem(
          color: _SeatGrid.silverColor,
          label: l10n.seatsLegendLabel('silver'),
        ),
        _LegendItem(
          color: _SeatGrid.bronzeColor,
          label: l10n.seatsLegendLabel('bronze'),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({required this.seats, required this.query});

  static const silverColor = Color(0xFF9E9E9E);
  static const bronzeColor = Color(0xFFC77B3B);

  /// 12x12 cells split into 4-cell bands: band 0 = gold, 1 = silver,
  /// 2 = bronze, using max(rowBand, colBand) so both scroll directions
  /// move gold → silver → bronze.
  static const bandSize = 4;
  static const gridSize = 12;

  static const _cellWidth = 66.0;
  static const _cellHeight = 80.0;
  static const _cellGap = 6.0;

  final List<Seat> seats;
  final String query;

  static SeatTier tierForCell(int row, int col) {
    final rowBand = row ~/ bandSize;
    final colBand = col ~/ bandSize;
    final band = rowBand > colBand ? rowBand : colBand;
    return switch (band) {
      0 => SeatTier.gold,
      1 => SeatTier.silver,
      _ => SeatTier.bronze,
    };
  }

  @override
  Widget build(BuildContext context) {
    final byTier = <SeatTier, List<Seat>>{
      SeatTier.gold: [],
      SeatTier.silver: [],
      SeatTier.bronze: [],
    };
    for (final seat in seats) {
      byTier[seat.tier]?.add(seat);
    }
    for (final list in byTier.values) {
      list.sort((a, b) => a.position.compareTo(b.position));
    }

    final cursors = <SeatTier, int>{
      SeatTier.gold: 0,
      SeatTier.silver: 0,
      SeatTier.bronze: 0,
    };

    final rows = <Widget>[];
    for (var row = 0; row < gridSize; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < gridSize; col++) {
        final tier = tierForCell(row, col);
        final tierSeats = byTier[tier]!;
        final cursor = cursors[tier]!;
        final seat = cursor < tierSeats.length ? tierSeats[cursor] : null;
        cursors[tier] = cursor + 1;

        cells.add(
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: _cellGap,
              bottom: _cellGap,
            ),
            child: _SeatCell(tier: tier, seat: seat, dimmed: _isDimmed(seat)),
          ),
        );
      }
      rows.add(Row(mainAxisSize: MainAxisSize.min, children: cells));
    }

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.xs,
        AppSpacing.screenHorizontal,
        AppSpacing.shellScrollBottom,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        ),
      ),
    );
  }

  bool _isDimmed(Seat? seat) {
    if (query.isEmpty) {
      return false;
    }
    final name = seat?.holder?.name;
    if (name == null) {
      return true;
    }
    return !name.toLowerCase().contains(query.toLowerCase());
  }
}

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.tier,
    required this.seat,
    this.dimmed = false,
  });

  final SeatTier tier;
  final Seat? seat;
  final bool dimmed;

  Color _getTierColor(BuildContext context) {
    return switch (tier) {
      SeatTier.gold => context.colors.primaryYellow,
      SeatTier.silver => _SeatGrid.silverColor,
      _ => _SeatGrid.bronzeColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tierColor = _getTierColor(context);
    final holder = seat?.holder;
    final isOccupied = seat != null && !seat!.isAvailable && holder != null;

    final cell = InkWell(
      onTap: () => _onTap(context),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: _SeatGrid._cellWidth,
        height: _SeatGrid._cellHeight,
        padding: const EdgeInsetsDirectional.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: colors.background.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tierColor.withValues(
              alpha: tier == SeatTier.gold ? 0.8 : 0.55,
            ),
            width: 1.2,
          ),
        ),
        child: isOccupied
            ? _OccupiedContent(holder: holder, tierColor: tierColor)
            : _AvailableContent(priceLabel: _priceLabel),
      ),
    );

    if (!dimmed) {
      return cell;
    }
    return Opacity(opacity: 0.25, child: cell);
  }

  String get _priceLabel {
    final price = seat?.price;
    if (price != null) {
      return price.label;
    }
    final fallback = switch (tier) {
      SeatTier.gold => 499,
      SeatTier.silver => 299,
      _ => 149,
    };
    return '$fallback AED';
  }

  void _onTap(BuildContext context) {
    final currentSeat = seat;
    if (currentSeat == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).seatsMoreSeatsOpeningSoon,
            ),
          ),
        );
      return;
    }

    if (currentSeat.isAvailable) {
      _showSeatSheet(context, currentSeat);
    } else {
      _showInfluencerSheet(context, currentSeat);
    }
  }

  void _showSeatSheet(BuildContext context, Seat seat) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return _SeatDetailSheet(
          seat: seat,
          tierColor: _getTierColor(context),
          onBookNow: () {
            final l10n = AppLocalizations.of(context);
            final tierKey = _seatTierKey(seat.tier);
            Navigator.of(sheetContext).pop();
            context.push(
              AppRoutes.seatCheckout(
                seatId: seat.id,
                title: '${l10n.seatsSingularLabel(tierKey)} ${seat.position}',
                tier: l10n.seatsVisibilityPlacementLabel(tierKey),
                price: _priceLabel,
              ),
            );
          },
        );
      },
    );
  }

  void _showInfluencerSheet(BuildContext context, Seat seat) {
    final holder = seat.holder!;
    final tierColor = _getTierColor(context);
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetHandle(),
                ClipOval(
                  child: SizedBox(
                    width: 84,
                    height: 84,
                    child: PromooImage(
                      imageUrl: holder.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  holder.name,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: tierColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.seatsSingularLabel(_seatTierKey(seat.tier)),
                      style: Theme.of(sheetContext).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(l10n.seatsFollowComingSoon),
                              ),
                            );
                        },
                        child: Text(l10n.seatsFollow),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          context.push(AppRoutes.profileById(holder.id));
                        },
                        child: Text(l10n.seatsViewProfile),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvailableContent extends StatelessWidget {
  const _AvailableContent({required this.priceLabel});

  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.chair_outlined, color: context.colors.textPrimary, size: 20),
        const SizedBox(height: AppSpacing.xxxs),
        Text(
          AppLocalizations.of(context).seatsBookSeatLabel,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.colors.textPrimary,
            fontSize: 9,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          priceLabel,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.colors.accent.withValues(alpha: 0.9),
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _OccupiedContent extends StatelessWidget {
  const _OccupiedContent({required this.holder, required this.tierColor});

  final SeatHolder holder;
  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: SizedBox(
            width: 38,
            height: 38,
            child: PromooImage(imageUrl: holder.avatarUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: tierColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                holder.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SeatDetailSheet extends StatelessWidget {
  const _SeatDetailSheet({
    required this.seat,
    required this.tierColor,
    required this.onBookNow,
  });

  final Seat seat;
  final Color tierColor;
  final VoidCallback onBookNow;

  String? _descriptionFor(AppLocalizations l10n, SeatTier tier) {
    return switch (tier) {
      SeatTier.gold => l10n.seatsTierDescriptionGold,
      SeatTier.silver => l10n.seatsTierDescriptionSilver,
      SeatTier.bronze => l10n.seatsTierDescriptionBronze,
      SeatTier.unknown => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetHandle()),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: tierColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.seatsSingularLabel(_seatTierKey(seat.tier)),
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: onBookNow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.accent,
                    side: BorderSide(color: context.colors.accent),
                  ),
                  child: Text(l10n.seatsBookNow),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              seat.price?.label ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _descriptionFor(l10n, seat.tier) ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 5,
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.textPrimary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
