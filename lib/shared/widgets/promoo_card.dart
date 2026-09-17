import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class PromooCard extends StatelessWidget {
  const PromooCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.md),
    this.margin = EdgeInsets.zero,
    this.color,
    this.borderColor,
    this.elevated = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  /// Defaults to the theme's card surface when null.
  final Color? color;

  /// Defaults to the theme's hairline border when null.
  final Color? borderColor;
  final bool elevated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Padding(padding: padding, child: child);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? colors.cardSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderColor ?? colors.border),
        boxShadow: elevated ? colors.shadowCard : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: AppRadius.card,
                child: content,
              ),
      ),
    );
  }
}
