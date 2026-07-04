import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PromooLogoVariant { compact, full }

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

  static const compactAsset = 'assets/brand/promoo.svg';
  static const fullAsset = 'assets/brand/promoo3.svg';

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
    final logo = SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );

    return Semantics(
      image: true,
      label: semanticLabel,
      child: cropToArtwork
          ? SizedBox(
              width: width,
              height: height,
              child: ClipRect(
                child: Transform.scale(
                  scale: artworkScale,
                  alignment: const Alignment(0.04, 0.14),
                  child: logo,
                ),
              ),
            )
          : logo,
    );
  }
}
