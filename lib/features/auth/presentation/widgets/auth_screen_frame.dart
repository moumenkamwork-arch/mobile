import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_glow_background.dart';
import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/theme_mode_controller.dart';

class AuthScreenFrame extends ConsumerWidget {
  const AuthScreenFrame({
    super.key,
    required this.child,
    this.showBackButton = true,
  });

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    // Status icons follow the ambient theme: light on the dark glow, dark
    // on the light theme's paper-and-sunlight glow.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (showBackButton)
                              IconButton(
                                tooltip: l10n.commonBack,
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    // Login is the app root after the intro:
                                    // back leaves the app instead of
                                    // replaying the splash animation.
                                    SystemNavigator.pop();
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_rounded),
                              )
                            else
                              const SizedBox.shrink(),
                            IconButton(
                              tooltip: isDark
                                  ? l10n.headerSwitchToLightMode
                                  : l10n.headerSwitchToDarkMode,
                              onPressed: () {
                                final notifier = ref.read(
                                  themeModeProvider.notifier,
                                );
                                if (isDark) {
                                  notifier.setLight();
                                } else {
                                  notifier.setDark();
                                }
                              },
                              icon: Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                              ),
                            ),
                          ],
                        ),
                        if (!showBackButton)
                          const SizedBox(height: AppSpacing.lg),
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
