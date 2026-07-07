import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Recreates the bold "PROMOO" wordmark used on the client's real Login
/// header: the real "P" mark artwork (`assets/brand/p_mark.png`, cropped from
/// the brand SVG) combined with bold VarelaRound caps for "ROMOO".
///
/// No vector source for this exact bold wordmark was available from the
/// client, so the remaining letters are recreated in the documented logo font
/// (Varela Round, see AGENTS.md) rather than invented from scratch.
class PromooWordmark extends StatelessWidget {
  const PromooWordmark({
    super.key,
    this.height = 40,
    this.semanticLabel = 'Promoo logo',
  });

  final double height;
  final String semanticLabel;

  /// Natural aspect ratio of the cropped P-mark artwork (468x590 px).
  static const _pMarkAspectRatio = 468 / 590;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
            width: height * _pMarkAspectRatio,
            child: Image.asset(
              'assets/brand/p_mark.png',
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          ExcludeSemantics(
            child: Text(
              'ROMOO',
              style: TextStyle(
                fontFamily: AppTypography.logoFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: height * 0.72,
                color: AppColors.primaryYellow,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
