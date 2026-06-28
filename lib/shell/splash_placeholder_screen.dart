import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../shared/widgets/promoo_button.dart';
import '../shared/widgets/promoo_logo.dart';
import '../theme/app_spacing.dart';

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
  late final Animation<Offset> _welcomeOffset;
  late final Animation<double> _welcomeOpacity;
  late final Animation<double> _ctaOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _glowScale = Tween<double>(
      begin: 0.72,
      end: 1.16,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.56, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.06, 0.62, curve: Curves.easeOutCubic),
      ),
    );
    _welcomeOffset =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.42, 0.82, curve: Curves.easeOutCubic),
          ),
        );
    _welcomeOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.82, curve: Curves.easeOut),
    );
    _ctaOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.68, 1, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
            alignment: const Alignment(0, -0.12),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
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
                                      alpha: 0.22,
                                    ),
                                    blurRadius: 54,
                                    spreadRadius: 8,
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
                      child: const PromooLogo.full(width: 196, height: 128),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeTransition(
                      opacity: _welcomeOpacity,
                      child: SlideTransition(
                        position: _welcomeOffset,
                        child: Column(
                          children: [
                            Text(
                              'Welcome to Promoo',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Discover services, creators, and premium campaign spaces.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FadeTransition(
                      opacity: _ctaOpacity,
                      child: PromooButton.primary(
                        label: 'Enter Promoo',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => context.go(AppRoutes.login),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
