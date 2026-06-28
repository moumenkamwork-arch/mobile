import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_logo.dart';
import '../../../../theme/app_spacing.dart';

class AuthScreenFrame extends StatelessWidget {
  const AuthScreenFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
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
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Center(child: PromooLogo.full(width: 150, height: 64)),
                  const SizedBox(height: AppSpacing.xl),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
