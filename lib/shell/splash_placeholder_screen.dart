import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../shared/widgets/promoo_logo.dart';

class SplashPlaceholderScreen extends StatefulWidget {
  const SplashPlaceholderScreen({super.key});

  @override
  State<SplashPlaceholderScreen> createState() =>
      _SplashPlaceholderScreenState();
}

class _SplashPlaceholderScreenState extends State<SplashPlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 5600),
          )
          ..addStatusListener(_handleIntroStatus)
          ..forward();

    _glowScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.72,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 34,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.16,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.16,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 16,
      ),
    ]).animate(_controller);
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 18),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 28,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 38),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 16,
      ),
    ]).animate(_controller);
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.9), weight: 16),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1.07,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.07,
          end: 1.03,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.03,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 12,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LaunchGlowPainter(progress: _controller.value),
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
                  return Transform.scale(
                    scale: _glowScale.value,
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.card,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryYellow.withValues(
                                alpha: 0.28 + (_controller.value * 0.12),
                              ),
                              blurRadius: 86,
                              spreadRadius: 14,
                            ),
                          ],
                        ),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final logoWidth = (constraints.maxWidth * 0.72)
                        .clamp(240.0, 310.0)
                        .toDouble();

                    return PromooLogo.fullCropped(
                      width: logoWidth,
                      height: 160,
                      artworkScale: 2.65,
                      semanticLabel: 'Promoo intro logo',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleIntroStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      context.go(AppRoutes.login);
    }
  }
}

class _LaunchGlowPainter extends CustomPainter {
  const _LaunchGlowPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.42);
    final radius = size.shortestSide * (0.44 + progress * 0.22);
    final warmPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryYellow.withValues(alpha: 0.34 * progress),
          AppColors.darkYellow.withValues(alpha: 0.12 * progress),
          Colors.transparent,
        ],
        stops: const [0, 0.34, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, warmPaint);

    final shimmerProgress = ((progress - 0.26) / 0.54).clamp(0.0, 1.0);
    if (shimmerProgress > 0 && shimmerProgress < 1) {
      final shimmerCenter = Offset(
        size.width * (-0.18 + (1.36 * shimmerProgress)),
        size.height * 0.45,
      );
      final shimmerRect = Rect.fromCenter(
        center: shimmerCenter,
        width: size.width * 0.32,
        height: size.height * 0.8,
      );
      final shimmerPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.softYellow.withValues(alpha: 0.14),
            Colors.transparent,
          ],
          stops: const [0, 0.5, 1],
        ).createShader(shimmerRect);

      canvas
        ..save()
        ..translate(shimmerCenter.dx, shimmerCenter.dy)
        ..rotate(-0.32)
        ..translate(-shimmerCenter.dx, -shimmerCenter.dy)
        ..drawRRect(
          RRect.fromRectAndRadius(shimmerRect, const Radius.circular(120)),
          shimmerPaint,
        )
        ..restore();
    }

    final sweepTop = size.height * (0.28 + progress * 0.12);
    final sweepPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          AppColors.softYellow.withValues(alpha: 0.1 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, sweepTop, size.width, 96));

    canvas.drawRect(Rect.fromLTWH(0, sweepTop, size.width, 96), sweepPaint);
  }

  @override
  bool shouldRepaint(_LaunchGlowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
