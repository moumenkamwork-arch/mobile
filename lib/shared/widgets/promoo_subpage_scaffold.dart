import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_names.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'promoo_glow_background.dart';

/// Full-screen sub-page chrome matching the original app's inner pages
/// (Edit Profile, Add New AD, Packages...): back arrow + title header over
/// the brand corner glow, no bottom navigation.
class PromooSubpageScaffold extends StatelessWidget {
  const PromooSubpageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.bottomBar,
    this.scrollable = true,
  });

  final String title;
  final Widget child;
  final Widget? bottomBar;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.xs,
        AppSpacing.screenHorizontal,
        AppSpacing.xl,
      ),
      child: child,
    );

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: PromooGlowBackground(intensity: 0.55)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.profile);
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: scrollable
                      ? SingleChildScrollView(child: content)
                      : content,
                ),
                if (bottomBar != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.xs,
                      AppSpacing.screenHorizontal,
                      AppSpacing.md,
                    ),
                    child: bottomBar!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
