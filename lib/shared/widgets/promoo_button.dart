import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

enum PromooButtonVariant { primary, secondary, tertiary, destructive }

class PromooButton extends StatelessWidget {
  const PromooButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PromooButtonVariant.primary,
    this.fullWidth = false,
  });

  const PromooButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  }) : variant = PromooButtonVariant.primary;

  const PromooButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  }) : variant = PromooButtonVariant.secondary;

  const PromooButton.tertiary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  }) : variant = PromooButtonVariant.tertiary;

  const PromooButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  }) : variant = PromooButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PromooButtonVariant variant;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final content = _ButtonContent(label: label, icon: icon);
    final button = switch (variant) {
      PromooButtonVariant.primary => ElevatedButton(
        onPressed: onPressed,
        child: content,
      ),
      PromooButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        child: content,
      ),
      PromooButtonVariant.tertiary => TextButton(
        onPressed: onPressed,
        child: content,
      ),
      PromooButtonVariant.destructive => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.textPrimary,
        ),
        child: content,
      ),
    };

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.touchTarget),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
