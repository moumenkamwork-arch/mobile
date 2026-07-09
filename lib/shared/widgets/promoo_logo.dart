import 'package:flutter/material.dart';

enum PromooLogoVariant { compact, full }

/// Brand logo used across the app (header, cards, previews).
///
/// Renders the Promoo logo artwork: transparent PNGs for the "P" mark
/// (`promoo_mark.png`, brand yellow — brand-fixed, used only on the dark
/// bottom-nav chip) and the full "Promoo" wordmark, which comes in two
/// colorways so it stays legible on either theme with no background plate:
/// [fullAssetDark] (brand yellow, `promoo_wordmark.png`) on the dark theme,
/// [fullAssetLight] (ink black + olive accent, `promoo_wordmark_light.png`)
/// on the light theme. The launch intro keeps its own dedicated treatment
/// and does not use this widget.
///
/// [cropToArtwork] and [artworkScale] are kept for API compatibility with
/// the old padded-SVG assets; the new assets are tightly cropped so no
/// zoom/crop is applied anymore.
class PromooLogo extends StatelessWidget {
  const PromooLogo({
    super.key,
    required this.variant,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
  }) : cropToArtwork = false,
       artworkScale = 1;

  const PromooLogo.compact({
    super.key,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
  }) : variant = PromooLogoVariant.compact,
       cropToArtwork = false,
       artworkScale = 1;

  const PromooLogo.full({
    super.key,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
  }) : variant = PromooLogoVariant.full,
       cropToArtwork = false,
       artworkScale = 1;

  const PromooLogo.fullCropped({
    super.key,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
    this.artworkScale = 4.1,
  }) : variant = PromooLogoVariant.full,
       cropToArtwork = true;

  static const compactAsset = 'assets/brand/new_logo/promoo_mark.png';
  static const fullAssetDark = 'assets/brand/new_logo/promoo_wordmark.png';
  static const fullAssetLight =
      'assets/brand/new_logo/promoo_wordmark_light.png';

  final PromooLogoVariant variant;
  final double? width;
  final double? height;
  final String semanticLabel;
  final bool cropToArtwork;
  final double artworkScale;

  String _assetFor(BuildContext context) {
    return switch (variant) {
      PromooLogoVariant.compact => compactAsset,
      PromooLogoVariant.full =>
        Theme.of(context).brightness == Brightness.dark
            ? fullAssetDark
            : fullAssetLight,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          _assetFor(context),
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
