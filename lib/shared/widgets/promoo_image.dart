import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class PromooImage extends StatelessWidget {
  const PromooImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.fallbackIcon = Icons.auto_awesome_rounded,
  });

  final String? imageUrl;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final source = imageUrl?.trim();
    if (source == null || source.isEmpty) {
      return _ImageFallback(icon: fallbackIcon, semanticLabel: semanticLabel);
    }

    final uri = Uri.tryParse(source);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return Image.network(
        source,
        fit: fit,
        alignment: alignment,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _ImageFallback(
            icon: fallbackIcon,
            semanticLabel: semanticLabel,
            showPulse: true,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _ImageFallback(
            icon: fallbackIcon,
            semanticLabel: semanticLabel,
          );
        },
      );
    }

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: fit,
        alignment: alignment,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) {
          return _ImageFallback(
            icon: fallbackIcon,
            semanticLabel: semanticLabel,
          );
        },
      );
    }

    return _ImageFallback(icon: fallbackIcon, semanticLabel: semanticLabel);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({
    required this.icon,
    this.semanticLabel,
    this.showPulse = false,
  });

  final IconData icon;
  final String? semanticLabel;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: semanticLabel != null,
      label: semanticLabel,
      child: _decoratedFallback(context),
    );
  }

  Widget _decoratedFallback(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            colors.elevatedSurface,
            colors.cardSurface,
            colors.darkYellow.withValues(alpha: 0.24),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: AppSpacing.touchTarget,
          height: AppSpacing.touchTarget,
          alignment: Alignment.center,
          // Dark scrim in both modes so the brand-yellow icon stays legible
          // over any fallback gradient.
          decoration: BoxDecoration(
            color: showPulse
                ? colors.overlay.withValues(alpha: 0.35)
                : colors.overlay,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.brandYellow.withValues(alpha: 0.4),
            ),
          ),
          child: Icon(icon, color: AppColors.brandYellow, size: 22),
        ),
      ),
    );
  }
}
