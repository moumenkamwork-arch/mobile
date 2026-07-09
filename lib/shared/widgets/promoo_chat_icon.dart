import 'package:flutter/material.dart';

/// Recreates the original app's "Chats" glyph: two overlapping speech
/// bubbles (a larger one behind, upper-right; a smaller one in front,
/// lower-left) — distinct from a single chat bubble, which reads as "one
/// message" rather than "your conversations".
///
/// Built from two of Flutter's own [Icons.chat_bubble_outline_rounded]
/// glyphs so each bubble keeps a polished, correctly-drawn outline; the
/// back bubble is notched where the front bubble overlaps it so the two
/// strokes never double up, regardless of what's behind them.
class PromooChatIcon extends StatelessWidget {
  const PromooChatIcon({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color;
    final backSize = size * 0.72;
    final frontSize = size * 0.56;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: 0,
            end: 0,
            child: ClipPath(
              clipper: _NotchClipper(
                hole: Rect.fromLTWH(
                  -size * 0.12,
                  backSize - frontSize * 0.22,
                  frontSize * 1.18,
                  frontSize * 1.05,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: backSize,
                color: iconColor,
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: frontSize,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips out [hole] (a rounded-rect region) from the painted child, so
/// content under it stays fully transparent — used to "erase" the part of
/// the back bubble that the front bubble sits on top of.
class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper({required this.hole});

  final Rect hole;

  @override
  Path getClip(Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final notch = Path()
      ..addRRect(
        RRect.fromRectAndRadius(hole, Radius.circular(hole.width / 2)),
      );
    return Path.combine(PathOperation.difference, full, notch);
  }

  @override
  bool shouldReclip(covariant _NotchClipper oldClipper) {
    return oldClipper.hole != hole;
  }
}
