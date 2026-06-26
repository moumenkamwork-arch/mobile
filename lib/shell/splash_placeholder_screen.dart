import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../shared/widgets/promoo_button.dart';
import '../shared/widgets/promoo_logo.dart';
import '../shared/widgets/promoo_scaffold.dart';
import '../theme/app_spacing.dart';

class SplashPlaceholderScreen extends StatelessWidget {
  const SplashPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PromooScaffold(
      body: Align(
        alignment: const Alignment(0, -0.18),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PromooLogo.full(width: 180, height: 120),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Welcome to Promoo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Discover services, creators, and premium campaign spaces.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              PromooButton.primary(
                label: 'Enter Promoo',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
