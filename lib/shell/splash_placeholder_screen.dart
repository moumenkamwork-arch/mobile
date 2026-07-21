import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../shared/widgets/promoo_glow_background.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// Animated launch intro matching the client's real app entry: "Promoo"
/// reveals letter by letter (each letter brightening from a dim, desaturated
/// tone to full brand yellow) while the letter spacing collapses from wide to
/// tight, then holds before fading into Login.
class SplashPlaceholderScreen extends StatefulWidget {
  const SplashPlaceholderScreen({super.key});

  /// Fixed intro length before `_handleIntroStatus` force-navigates
  /// (`context.go` — replaces the whole stack). Exposed so anything that
  /// pushes a route during cold start (e.g. a notification deep link, see
  /// `push_notification_service.dart`) knows how long to wait first —
  /// otherwise this screen's own navigation wipes it out a moment later.
  static const introDuration = Duration(milliseconds: 2400);

  @override
  State<SplashPlaceholderScreen> createState() =>
      _SplashPlaceholderScreenState();
}

class _SplashPlaceholderScreenState extends State<SplashPlaceholderScreen>
    with SingleTickerProviderStateMixin {
  static const _word = 'Promoo';
  static const _revealEnd = 0.55;
  static const _holdEnd = 0.8;

  late final AnimationController _controller;
  late final Animation<double> _letterGap;
  late final Animation<double> _wordOpacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: SplashPlaceholderScreen.introDuration,
          )
          ..addStatusListener(_handleIntroStatus)
          ..forward();

    _letterGap = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 13,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: _revealEnd * 100,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: (1 - _revealEnd) * 100,
      ),
    ]).animate(_controller);

    _wordOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: _holdEnd * 100,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: (1 - _holdEnd) * 100,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleIntroStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The launch intro is a fixed brand moment: always the black treatment,
    // regardless of the selected theme mode.
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: AppColors.brandBlack,
        body: _buildIntroBody(),
      ),
    );
  }

  Widget _buildIntroBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return PromooGlowBackground(
                intensity: Curves.easeOut.transform(_controller.value),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _wordOpacity.value,
                  child: Semantics(
                    label: 'Promoo intro',
                    child: ExcludeSemantics(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildLetters(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLetters() {
    final children = <Widget>[];
    final letterSpan = _revealEnd / _word.length;

    for (var i = 0; i < _word.length; i++) {
      final start = i * letterSpan;
      if (_controller.value < start) {
        break;
      }
      final end = (start + letterSpan * 1.6).clamp(0.0, _revealEnd);
      final local = end > start
          ? ((_controller.value - start) / (end - start)).clamp(0.0, 1.0)
          : 1.0;

      if (children.isNotEmpty) {
        children.add(SizedBox(width: _letterGap.value));
      }
      children.add(_RevealLetter(letter: _word[i], progress: local));
    }
    return children;
  }

  void _handleIntroStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      context.go(AppRoutes.login);
    }
  }
}

class _RevealLetter extends StatelessWidget {
  const _RevealLetter({required this.letter, required this.progress});

  final String letter;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(progress);
    // Brand-fixed letter colors (the intro is always the dark treatment).
    final color = Color.lerp(
      AppColors.dark.darkYellow.withValues(alpha: 0.32),
      AppColors.brandYellow,
      eased,
    );

    return Text(
      letter,
      style: TextStyle(
        fontFamily: AppTypography.logoFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 46,
        color: color,
        height: 1.0,
      ),
    );
  }
}
