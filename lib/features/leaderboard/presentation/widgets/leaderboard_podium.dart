import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_image.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/leaderboard_profile.dart';
import 'leaderboard_labels.dart';
import 'leaderboard_medal.dart';

/// The head of the Cup: an actual medal ceremony. Second stands to the left on
/// a silver block, the champion is raised in the centre on the tall gold block
/// under a crown and a soft glow, third stands to the right on the short bronze
/// block. Each block carries its rank numeral embossed into the face, so the
/// heights and the metals — not a stack of identical yellow circles — are what
/// tell you who won.
class LeaderboardPodium extends StatefulWidget {
  const LeaderboardPodium({
    super.key,
    required this.profiles,
    this.onProfileSelected,
  });

  final List<LeaderboardProfile> profiles;
  final ValueChanged<LeaderboardProfile>? onProfileSelected;

  @override
  State<LeaderboardPodium> createState() => _LeaderboardPodiumState();
}

class _LeaderboardPodiumState extends State<LeaderboardPodium>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduced-motion users get the finished ceremony with no rise/fade.
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = [...widget.profiles]
      ..sort((a, b) => a.rank.value.compareTo(b.rank.value));

    final champion = sorted.first;
    final second = sorted.length > 1 ? sorted[1] : null;
    final third = sorted.length > 2 ? sorted[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: second == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  profile: second,
                  tier: MedalTier.silver,
                  controller: _controller,
                  order: 0,
                  onTap: _tapHandler(second),
                ),
        ),
        Expanded(
          child: _PodiumPlace(
            profile: champion,
            tier: MedalTier.gold,
            controller: _controller,
            order: 2,
            onTap: _tapHandler(champion),
          ),
        ),
        Expanded(
          child: third == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  profile: third,
                  tier: MedalTier.bronze,
                  controller: _controller,
                  order: 1,
                  onTap: _tapHandler(third),
                ),
        ),
      ],
    );
  }

  VoidCallback? _tapHandler(LeaderboardProfile profile) {
    final onSelected = widget.onProfileSelected;
    if (onSelected == null) {
      return null;
    }
    return () => onSelected(profile);
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({
    required this.profile,
    required this.tier,
    required this.controller,
    required this.order,
    this.onTap,
  });

  final LeaderboardProfile profile;
  final MedalTier tier;
  final AnimationController controller;

  /// 0..2 — later positions settle last, so the crowd's eye ends on the
  /// champion (order 2). Also drives the staggered rise.
  final int order;
  final VoidCallback? onTap;

  bool get _isChampion => tier == MedalTier.gold;

  double get _avatarDiameter => _isChampion ? 92 : 64;
  double get _pillarHeight => switch (tier) {
    MedalTier.gold => 112,
    MedalTier.silver => 78,
    MedalTier.bronze => 58,
  };

  @override
  Widget build(BuildContext context) {
    // Each place rises and fades in on its own beat within the 0..1 timeline.
    final start = 0.12 * order;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, (start + 0.7).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 26),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.xxs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isChampion)
                Icon(Icons.workspace_premium_rounded,
                    color: tier.sheen, size: 26)
              else
                const SizedBox(height: 26),
              const SizedBox(height: AppSpacing.xs),
              _MedalAvatar(
                profile: profile,
                tier: tier,
                diameter: _avatarDiameter,
                glow: _isChampion,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                profile.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: (_isChampion
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyLarge)
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                // The champion earns the "Champion / …" descriptor; the
                // crown, glow and gold already say it, so the runners-up just
                // carry their reach.
                _isChampion
                    ? AppLocalizations.of(context).leaderboardChampionLine(
                        leaderboardFollowersLabel(context, profile),
                      )
                    : leaderboardFollowersLabel(context, profile),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              _PodiumBlock(tier: tier, height: _pillarHeight),
            ],
          ),
        ),
      ),
    );
  }
}

/// A circular avatar wearing a metallic ring, with a medal disc struck over its
/// lower edge carrying the rank numeral.
class _MedalAvatar extends StatelessWidget {
  const _MedalAvatar({
    required this.profile,
    required this.tier,
    required this.diameter,
    required this.glow,
  });

  final LeaderboardProfile profile;
  final MedalTier tier;
  final double diameter;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final ringWidth = glow ? 3.5 : 2.5;
    final discSize = diameter * 0.36;

    return SizedBox(
      // Room for the medal disc that hangs past the avatar's bottom edge.
      width: diameter,
      height: diameter + discSize * 0.4,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tier.sheen, tier.shade],
              ),
              boxShadow: glow
                  ? [
                      BoxShadow(
                        color: tier.sheen.withValues(alpha: 0.45),
                        blurRadius: 34,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            padding: EdgeInsets.all(ringWidth),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.brandBlack,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: profile.avatarUrl == null
                    ? Center(
                        child: Text(
                          _initialsFor(profile.displayName),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: tier.sheen),
                        ),
                      )
                    : PromooImage(
                        imageUrl: profile.avatarUrl,
                        fallbackIcon: Icons.person_rounded,
                        semanticLabel: profile.displayName,
                      ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            child: Container(
              width: discSize,
              height: discSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [tier.sheen, tier.shade],
                ),
                border: Border.all(color: context.colors.background, width: 2),
              ),
              child: Text(
                '${profile.rank.value}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: tier.onSheen,
                  fontWeight: FontWeight.w900,
                  fontSize: discSize * 0.5,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The physical block each contestant stands on. Height carries rank; the
/// numeral is embossed into the face; a bright metal edge caps the top.
class _PodiumBlock extends StatelessWidget {
  const _PodiumBlock({required this.tier, required this.height});

  final MedalTier tier;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.elevatedSurface, colors.cardSurface],
        ),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          // Metallic cap along the block's leading edge.
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              gradient: LinearGradient(
                colors: [tier.shade, tier.sheen, tier.shade],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Builder(
                builder: (context) {
                  // Emboss reads as engraved metal on both themes: the bright
                  // sheen sits on the dark blocks, the darker shade sits on
                  // light mode's near-white blocks (where the sheen would wash
                  // out).
                  final isLight =
                      Theme.of(context).brightness == Brightness.light;
                  return Text(
                    '${_rankForTier(tier)}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: (isLight ? tier.shade : tier.sheen)
                          .withValues(alpha: isLight ? 0.42 : 0.24),
                      fontWeight: FontWeight.w900,
                      fontSize: tier == MedalTier.gold ? 46 : 34,
                      height: 1,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _rankForTier(MedalTier tier) {
    return switch (tier) {
      MedalTier.gold => 1,
      MedalTier.silver => 2,
      MedalTier.bronze => 3,
    };
  }
}

String _initialsFor(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return 'P';
  }
  if (parts.length == 1) {
    return _firstCharacter(parts.first).toUpperCase();
  }
  return '${_firstCharacter(parts.first)}${_firstCharacter(parts.last)}'
      .toUpperCase();
}

String _firstCharacter(String value) {
  return String.fromCharCode(value.runes.first);
}
