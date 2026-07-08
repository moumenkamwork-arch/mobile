import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
    // Auth screens are always the dark brand moment; keep status bar icons
    // light on the black glow background.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
                                  // Login is the app root after the intro:
                                  // back leaves the app instead of replaying
                                  // the splash animation.
                                  SystemNavigator.pop();
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
      ),
    );
  }
}
