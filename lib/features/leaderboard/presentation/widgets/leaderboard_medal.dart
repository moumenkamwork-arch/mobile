import 'package:flutter/material.dart';

/// Metallic medal identity for the top three Cup positions.
///
/// These are deliberately *not* theme tokens: a gold/silver/bronze medal is
/// metallic in both light and dark mode (the surfaces around it change, the
/// metal doesn't), so the palette is fixed. Gold is the brand yellow so the
/// champion still reads as unmistakably Promoo; silver and bronze are the two
/// extra tiers the flat design never had, which is what let every position
/// blur into the same yellow-on-black sameness.
enum MedalTier { gold, silver, bronze }

extension MedalTierPalette on MedalTier {
  /// The bright face of the metal — rings, numerals, the pillar's top edge.
  Color get sheen {
    return switch (this) {
      MedalTier.gold => const Color(0xFFFFE604),
      MedalTier.silver => const Color(0xFFDCE0E6),
      MedalTier.bronze => const Color(0xFFD98A45),
    };
  }

  /// The shadowed side of the metal — gradients and embossed lowlights.
  Color get shade {
    return switch (this) {
      MedalTier.gold => const Color(0xFFC7A600),
      MedalTier.silver => const Color(0xFF8A9099),
      MedalTier.bronze => const Color(0xFF9C5A24),
    };
  }

  /// Ink that stays legible sitting directly on [sheen] (medal-disc numeral).
  Color get onSheen {
    return switch (this) {
      MedalTier.gold => const Color(0xFF141414),
      MedalTier.silver => const Color(0xFF20242B),
      MedalTier.bronze => const Color(0xFF2A1608),
    };
  }
}

/// Maps a 1-based rank to its medal, or null for 4th place and below (which
/// stand in the ranked list, not on the podium).
MedalTier? medalForRank(int rank) {
  return switch (rank) {
    1 => MedalTier.gold,
    2 => MedalTier.silver,
    3 => MedalTier.bronze,
    _ => null,
  };
}
