import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

const _silverSeatColor = Color(0xFF9E9E9E);
const _bronzeSeatColor = Color(0xFFC77B3B);

/// Maps a [SeatTier] to the ICU `select` key used by the `seats*Label`
/// messages (`seatsLegendLabel`/`seatsSingularLabel`/
/// `seatsVisibilityPlacementLabel`). Kept as a `select` (not naive string
/// concatenation) because adjective+noun order differs by language — Arabic
/// "Gold Seat" is "مقعد ذهبي" (noun first), not a tier word glued onto "Seat".
String _seatTierKey(SeatTier tier) => tier.apiValue ?? 'unknown';

/// Influencer directory: search bar, tier legend, and a roster of the
/// influencers currently holding a seat. Read-only — seats are allocated
/// outside the app, so there is no booking or payment surface here.
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
        // Only seats that are actually taken are listed, so the page reads
        // as a roster of real influencers rather than a map of open slots.
        return _OccupiedSeatsGrid(
          seats: state.seats.where((seat) => !seat.isAvailable).toList(),
          query: _query,
        );
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

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: _StatChip(
        icon: Icons.people_alt_rounded,
        value: '$influencers',
        label: l10n.seatsStatsInfluencers,
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
          color: _silverSeatColor,
          label: l10n.seatsLegendLabel('silver'),
        ),
        _LegendItem(
          color: _bronzeSeatColor,
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

Color _tierColorFor(BuildContext context, SeatTier tier) {
  return switch (tier) {
    SeatTier.gold => context.colors.primaryYellow,
    SeatTier.silver => _silverSeatColor,
    _ => _bronzeSeatColor,
  };
}

/// Shared between the influencer's full seat map (`_SeatCell`) and the
/// compact occupied-only roster (`_OccupiedSeatTile`) everyone else gets.
void _showInfluencerSheet(BuildContext context, Seat seat) {
  final holder = seat.holder!;
  final tierColor = _tierColorFor(context, seat.tier);
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
              // Only "View profile" — following happens on the profile page
              // itself, so there is no half-wired action in this sheet.
              SizedBox(
                width: double.infinity,
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
        ),
      );
    },
  );
}

class _OccupiedSeatsGrid extends StatelessWidget {
  const _OccupiedSeatsGrid({required this.seats, required this.query});

  final List<Seat> seats;
  final String query;

  static int _tierRank(SeatTier tier) => switch (tier) {
    SeatTier.gold => 0,
    SeatTier.silver => 1,
    SeatTier.bronze => 2,
    SeatTier.unknown => 3,
  };

  bool _isDimmed(Seat seat) {
    if (query.isEmpty) {
      return false;
    }
    final name = seat.holder?.name;
    if (name == null) {
      return true;
    }
    return !name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    if (seats.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return Center(
        child: PromooErrorState(
          title: l10n.seatsEmptyTitle,
          message: l10n.seatsEmptyMessage,
        ),
      );
    }

    final sorted = [...seats]
      ..sort((a, b) {
        final tierOrder = _tierRank(a.tier).compareTo(_tierRank(b.tier));
        return tierOrder != 0 ? tierOrder : a.position.compareTo(b.position);
      });

    // A plain, count-sized grid — unlike the influencer's full seat map (a
    // fixed-size arena layout with intentionally empty bookable slots),
    // everyone else only ever sees seats that are actually occupied, so it
    // should look like a normal roster, not a sparse map full of gaps.
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.xs,
        AppSpacing.screenHorizontal,
        AppSpacing.shellScrollBottom,
      ),
      itemCount: sorted.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final seat = sorted[index];
        return _OccupiedSeatTile(seat: seat, dimmed: _isDimmed(seat));
      },
    );
  }
}

class _OccupiedSeatTile extends StatelessWidget {
  const _OccupiedSeatTile({required this.seat, this.dimmed = false});

  final Seat seat;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final tierColor = _tierColorFor(context, seat.tier);
    final cell = InkWell(
      onTap: () => _showInfluencerSheet(context, seat),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsetsDirectional.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: context.colors.background.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tierColor.withValues(
              alpha: seat.tier == SeatTier.gold ? 0.8 : 0.55,
            ),
            width: 1.2,
          ),
        ),
        child: _OccupiedContent(holder: seat.holder!, tierColor: tierColor),
      ),
    );
    if (!dimmed) {
      return cell;
    }
    return Opacity(opacity: 0.25, child: cell);
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
