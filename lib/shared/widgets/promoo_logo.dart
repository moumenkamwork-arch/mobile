import 'package:flutter/material.dart';

enum PromooLogoVariant { compact, full }

/// Brand logo used across the app (header, cards, previews).
///
/// Renders the NEW Promoo logo artwork (owner decision, 2026-07-06):
/// transparent PNGs processed from `new logo/` — `promoo_mark.png` (the "P")
/// and `promoo_wordmark.png` ("Promoo"). The launch intro and Login keep
/// their own dedicated treatments and do not use this widget.
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
  static const fullAsset = 'assets/brand/new_logo/promoo_wordmark.png';

  final PromooLogoVariant variant;
  final double? width;
  final double? height;
  final String semanticLabel;
  final bool cropToArtwork;
  final double artworkScale;

  String get assetName {
    return switch (variant) {
      PromooLogoVariant.compact => compactAsset,
      PromooLogoVariant.full => fullAsset,
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
          assetName,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
