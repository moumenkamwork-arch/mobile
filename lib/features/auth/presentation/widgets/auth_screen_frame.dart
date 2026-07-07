import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_glow_background.dart';
import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_spacing.dart';

class AuthScreenFrame extends StatelessWidget {
  const AuthScreenFrame({
    super.key,
    required this.child,
    this.showBackButton = true,
  });

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: PromooGlowBackground(intensity: 0.8)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.lg,
                    AppSpacing.screenHorizontal,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList.list(
                    children: [
                      if (showBackButton)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            tooltip: 'Back',
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go(AppRoutes.splash);
                              }
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                        )
                      else
                        const SizedBox(height: AppSpacing.xl),
                      const SizedBox(height: AppSpacing.sm),
                      const Center(
                        child: PromooLogo.full(
                          width: 280,
                          height: 96,
                          semanticLabel: 'Promoo auth logo',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      child,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
