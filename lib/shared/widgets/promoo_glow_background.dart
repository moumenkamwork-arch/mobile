import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Diagonal yellow corner glow used across the client's entry flow: a warm
/// yellow radial glow anchored at the bottom-left corner (see the client
/// entry video and the original MVP login screenshot).
///
/// Theme-aware: on the dark theme it is the original black screen with a
/// strong glow; on the light theme it becomes paper with a soft sunlight
/// wash so sub-pages (Edit Profile, Add New Ad...) stay readable. Screens
/// that must ALWAYS be the dark brand moment (splash, login, register) wrap
/// themselves in `Theme(data: AppTheme.dark, ...)`.
///
/// [intensity] scales the glow alpha from 0 (invisible) to 1 (full), so the
/// splash can grow the glow over time while static screens pass a constant.
class PromooGlowBackground extends StatelessWidget {
  const PromooGlowBackground({super.key, this.intensity = 1.0});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    final clamped = intensity.clamp(0.0, 1.0);
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Yellow floods black beautifully; on paper it needs a lighter hand.
    final strongAlpha = isDark ? 0.62 : 0.30;
    final softAlpha = isDark ? 0.22 : 0.10;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-1.05, 1.35),
            radius: 1.9,
            colors: [
              colors.primaryYellow.withValues(alpha: strongAlpha * clamped),
              colors.darkYellow.withValues(alpha: softAlpha * clamped),
              Colors.transparent,
            ],
            stops: const [0.0, 0.42, 0.78],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
