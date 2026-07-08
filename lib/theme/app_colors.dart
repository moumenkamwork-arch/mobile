import 'package:flutter/material.dart';

/// Promoo fixed brand color constants and default/dark theme fallbacks.
/// Use AppColors.brandBlack and AppColors.brandYellow for static brand constants.
/// Use context.colors for dynamic, theme-aware colors (supporting Dark/Light).
class AppColors {
  const AppColors._();

  static const brandBlack = Color(0xFF000000);
  static const brandYellow = Color(0xFFFFE604);

  static const dark = AppThemeColors.dark;
  static const light = AppThemeColors.light;

  // Static fallback constants (matching the dark theme/brand colors)
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF101010);
  static const cardSurface = Color(0xFF181818);
  static const elevatedSurface = Color(0xFF202020);
  static const primaryYellow = brandYellow;
  static const softYellow = Color(0xFFFFF36A);
  static const darkYellow = Color(0xFFC7B000);
  static const accent = brandYellow;
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB8B8B8);
  static const textMuted = Color(0xFF7A7A7A);
  static const border = Color(0xFF2A2A2A);
  static const borderStrong = Color(0xFF3A3A3A);
  static const error = Color(0xFFFF4D4F);
  static const success = Color(0xFF3DDC84);
  static const warning = Color(0xFFFFC857);
  static const navBackground = Color(0xFF050505);
  static const overlay = Color(0x99000000);

  static const shadowCard = [
    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
  ];

  static const shadowElevated = [
    BoxShadow(color: Color(0x66000000), blurRadius: 28, offset: Offset(0, 16)),
  ];
}

/// Promoo semantic color tokens, resolved per theme.
/// Register this in ThemeData extensions, and access via context.colors.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.cardSurface,
    required this.elevatedSurface,
    required this.primaryYellow,
    required this.softYellow,
    required this.darkYellow,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.error,
    required this.success,
    required this.warning,
    required this.navBackground,
    required this.overlay,
    required this.shadowCard,
    required this.shadowElevated,
  });

  /// Brand reference palette (the original Promoo look).
  static const dark = AppThemeColors(
    background: Color(0xFF000000),
    surface: Color(0xFF101010),
    cardSurface: Color(0xFF181818),
    elevatedSurface: Color(0xFF202020),
    primaryYellow: AppColors.brandYellow,
    softYellow: Color(0xFFFFF36A),
    darkYellow: Color(0xFFC7B000),
    accent: AppColors.brandYellow,
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB8B8B8),
    textMuted: Color(0xFF7A7A7A),
    border: Color(0xFF2A2A2A),
    borderStrong: Color(0xFF3A3A3A),
    error: Color(0xFFFF4D4F),
    success: Color(0xFF3DDC84),
    warning: Color(0xFFFFC857),
    navBackground: Color(0xFF050505),
    overlay: Color(0x99000000),
    shadowCard: AppColors.shadowCard,
    shadowElevated: AppColors.shadowElevated,
  );

  /// Daylight palette — ink on warm paper, yellow as highlighter fills only.
  static const light = AppThemeColors(
    background: Color(0xFFF7F6F1),
    surface: Color(0xFFFFFFFF),
    cardSurface: Color(0xFFFFFFFF),
    elevatedSurface: Color(0xFFEFEDE3),
    primaryYellow: AppColors.brandYellow,
    softYellow: Color(0xFFFFF36A),
    darkYellow: Color(0xFFC7B000),
    accent: Color(0xFF7A6900),
    textPrimary: Color(0xFF141414),
    textSecondary: Color(0xFF504E46),
    textMuted: Color(0xFF757263),
    border: Color(0xFFE7E4D9),
    borderStrong: Color(0xFFD2CEC0),
    error: Color(0xFFC62828),
    success: Color(0xFF1D7A46),
    warning: Color(0xFF8A5B00),
    navBackground: Color(0xFF050505),
    overlay: Color(0x99000000),
    shadowCard: [
      BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8)),
    ],
    shadowElevated: [
      BoxShadow(
        color: Color(0x24000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );

  final Color background;
  final Color surface;
  final Color cardSurface;
  final Color elevatedSurface;
  final Color primaryYellow;
  final Color softYellow;
  final Color darkYellow;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color error;
  final Color success;
  final Color warning;
  final Color navBackground;
  final Color overlay;
  final List<BoxShadow> shadowCard;
  final List<BoxShadow> shadowElevated;

  static AppThemeColors of(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>() ?? dark;
  }

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? cardSurface,
    Color? elevatedSurface,
    Color? primaryYellow,
    Color? softYellow,
    Color? darkYellow,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? borderStrong,
    Color? error,
    Color? success,
    Color? warning,
    Color? navBackground,
    Color? overlay,
    List<BoxShadow>? shadowCard,
    List<BoxShadow>? shadowElevated,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardSurface: cardSurface ?? this.cardSurface,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      primaryYellow: primaryYellow ?? this.primaryYellow,
      softYellow: softYellow ?? this.softYellow,
      darkYellow: darkYellow ?? this.darkYellow,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      navBackground: navBackground ?? this.navBackground,
      overlay: overlay ?? this.overlay,
      shadowCard: shadowCard ?? this.shadowCard,
      shadowElevated: shadowElevated ?? this.shadowElevated,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      primaryYellow: Color.lerp(primaryYellow, other.primaryYellow, t)!,
      softYellow: Color.lerp(softYellow, other.softYellow, t)!,
      darkYellow: Color.lerp(darkYellow, other.darkYellow, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      shadowCard: t < 0.5 ? shadowCard : other.shadowCard,
      shadowElevated: t < 0.5 ? shadowElevated : other.shadowElevated,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppThemeColors get colors => AppThemeColors.of(this);
}
