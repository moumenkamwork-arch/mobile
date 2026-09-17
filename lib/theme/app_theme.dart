import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  /// Brand reference theme (Black).
  static ThemeData get dark {
    const colors = AppThemeColors.dark;
    return _build(
      colors: colors,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primaryYellow,
        onPrimary: AppColors.brandBlack,
        secondary: colors.softYellow,
        onSecondary: AppColors.brandBlack,
        error: colors.error,
        onError: colors.textPrimary,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        outline: colors.border,
      ),
      // Yellow works as ink on black, so snackbars sit on a raised surface.
      snackBarBackground: colors.elevatedSurface,
      snackBarForeground: colors.textPrimary,
    );
  }

  /// Daylight theme — same structure as [dark], light token values.
  static ThemeData get light {
    const colors = AppThemeColors.light;
    return _build(
      colors: colors,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primaryYellow,
        onPrimary: AppColors.brandBlack,
        secondary: colors.accent,
        onSecondary: Color(0xFFFFFFFF),
        error: colors.error,
        onError: Color(0xFFFFFFFF),
        surface: colors.surface,
        onSurface: colors.textPrimary,
        outline: colors.border,
      ),
      // Inverse snackbar: ink plate on paper.
      snackBarBackground: colors.textPrimary,
      snackBarForeground: const Color(0xFFFFFFFF),
    );
  }

  static ThemeData _build({
    required AppThemeColors colors,
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color snackBarBackground,
    required Color snackBarForeground,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.recommendedUiFontFamily,
      scaffoldBackgroundColor: colors.background,
      colorScheme: colorScheme,
    );

    return base.copyWith(
      extensions: [colors],
      textTheme: AppTypography.textTheme(base.textTheme, colors),
      iconTheme: IconThemeData(color: colors.textPrimary),
      dividerTheme: DividerThemeData(
        color: colors.border,
        space: 1,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: colors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: TextStyle(color: colors.textMuted),
        labelStyle: TextStyle(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryYellow,
          foregroundColor: AppColors.brandBlack,
          disabledBackgroundColor: colors.elevatedSurface,
          disabledForegroundColor: colors.textMuted,
          elevation: 0,
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          disabledForegroundColor: colors.textMuted,
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg,
          ),
          side: BorderSide(color: colors.borderStrong),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accent,
          disabledForegroundColor: colors.textMuted,
          minimumSize: const Size(
            AppSpacing.touchTarget,
            AppSpacing.touchTarget,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        circularTrackColor: colors.elevatedSurface,
        linearTrackColor: colors.elevatedSurface,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colors.surface,
        selectedColor: colors.elevatedSurface,
        disabledColor: colors.surface,
        side: BorderSide(color: colors.border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.cardSurface,
        modalBackgroundColor: colors.cardSurface,
        showDragHandle: true,
        dragHandleColor: colors.borderStrong,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.cardSurface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarBackground,
        contentTextStyle: TextStyle(
          color: snackBarForeground,
          fontFamily: AppTypography.recommendedUiFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
    );
  }
}
