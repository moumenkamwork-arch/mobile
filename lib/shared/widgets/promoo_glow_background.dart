import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Diagonal yellow corner glow used across the client's entry flow: black
/// screen with a warm yellow radial glow anchored at the bottom-left corner
/// (see the client entry video and the original MVP login screenshot).
///
/// [intensity] scales the glow alpha from 0 (invisible) to 1 (full), so the
/// splash can grow the glow over time while static screens pass a constant.
class PromooGlowBackground extends StatelessWidget {
  const PromooGlowBackground({super.key, this.intensity = 1.0});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    final clamped = intensity.clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-1.05, 1.35),
            radius: 1.9,
            colors: [
              AppColors.primaryYellow.withValues(alpha: 0.62 * clamped),
              AppColors.darkYellow.withValues(alpha: 0.22 * clamped),
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
