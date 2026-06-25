import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';

class PromooCard extends StatelessWidget {
  const PromooCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.md),
    this.margin = EdgeInsets.zero,
    this.color = AppColors.cardSurface,
    this.borderColor = AppColors.border,
    this.elevated = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final Color borderColor;
  final bool elevated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderColor),
        boxShadow: elevated ? AppShadows.card : null,
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
