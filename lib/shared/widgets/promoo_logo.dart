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
  });

  const PromooLogo.compact({
    super.key,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
  }) : variant = PromooLogoVariant.compact;

  const PromooLogo.full({
    super.key,
    this.width,
    this.height,
    this.semanticLabel = 'Promoo logo',
  }) : variant = PromooLogoVariant.full;

  static const compactAsset = 'assets/brand/promoo.svg';
  static const fullAsset = 'assets/brand/promoo3.svg';

  final PromooLogoVariant variant;
  final double? width;
  final double? height;
  final String semanticLabel;

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
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
      ),
    );
  }
}
