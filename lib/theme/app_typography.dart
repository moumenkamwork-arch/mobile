import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  const AppTypography._();

  static const recommendedUiFontFamily = 'Tajawal';

  /// Logo-only font (see AGENTS.md: "Logo font: Varela Round, logo only").
  /// Never used for general UI text.
  static const logoFontFamily = 'VarelaRound';

  /// Builds the shared Promoo type scale with the given palette's ink colors,
  /// so both themes use the exact same sizes/weights and only swap color.
  static TextTheme textTheme(TextTheme base, AppThemeColors colors) {
    TextStyle style(
      TextStyle? source, {
      required Color color,
      double? size,
      FontWeight? weight,
      double? height,
    }) {
      return (source ?? const TextStyle()).copyWith(
        color: color,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: 0,
      );
    }

    return base.copyWith(
      displayLarge: style(
        base.displayLarge,
        color: colors.textPrimary,
        size: 40,
        weight: FontWeight.w800,
        height: 1.05,
      ),
      displayMedium: style(
        base.displayMedium,
        color: colors.textPrimary,
        size: 32,
        weight: FontWeight.w800,
        height: 1.1,
      ),
      headlineSmall: style(
        base.headlineSmall,
        color: colors.textPrimary,
        size: 24,
        weight: FontWeight.w700,
        height: 1.2,
      ),
      titleLarge: style(
        base.titleLarge,
        color: colors.textPrimary,
        size: 20,
        weight: FontWeight.w700,
        height: 1.25,
      ),
      titleMedium: style(
        base.titleMedium,
        color: colors.textPrimary,
        size: 16,
        weight: FontWeight.w700,
        height: 1.3,
      ),
      bodyLarge: style(
        base.bodyLarge,
        color: colors.textPrimary,
        size: 16,
        weight: FontWeight.w500,
        height: 1.45,
      ),
      bodyMedium: style(
        base.bodyMedium,
        color: colors.textSecondary,
        size: 14,
        weight: FontWeight.w500,
        height: 1.45,
      ),
      bodySmall: style(
        base.bodySmall,
        color: colors.textMuted,
        size: 12,
        weight: FontWeight.w500,
        height: 1.35,
      ),
      labelLarge: style(
        base.labelLarge,
        color: colors.textPrimary,
        size: 14,
        weight: FontWeight.w700,
        height: 1.2,
      ),
      labelMedium: style(
        base.labelMedium,
        color: colors.textSecondary,
        size: 12,
        weight: FontWeight.w700,
        height: 1.2,
      ),
      labelSmall: style(
        base.labelSmall,
        color: colors.textMuted,
        size: 11,
        weight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }
}
