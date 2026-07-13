import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'promoo_image.dart';

/// Circular avatar image with a themed fallback fill, used for provider/
/// profile avatars on detail and list pages.
class PromooAvatarCircle extends StatelessWidget {
  const PromooAvatarCircle({
    super.key,
    this.imageUrl,
    required this.semanticLabel,
    this.fallbackIcon = Icons.person_rounded,
    this.size = 56,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  final String? imageUrl;
  final String semanticLabel;
  final IconData fallbackIcon;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.elevatedSurface,
        shape: BoxShape.circle,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
      child: ClipOval(
        child: PromooImage(
          imageUrl: imageUrl,
          semanticLabel: semanticLabel,
          fallbackIcon: fallbackIcon,
        ),
      ),
    );
  }
}
