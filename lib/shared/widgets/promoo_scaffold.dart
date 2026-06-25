import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'promoo_logo.dart';

class PromooScaffold extends StatelessWidget {
  const PromooScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions = const [],
    this.showLogo = false,
    this.bottomNavigationBar,
    this.padding = const EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.screenHorizontal,
    ),
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final String? title;
  final List<Widget> actions;
  final bool showLogo;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || showLogo || actions.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasHeader) ...[
                _PromooHeader(
                  title: title,
                  showLogo: showLogo,
                  actions: actions,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromooHeader extends StatelessWidget {
  const _PromooHeader({
    required this.title,
    required this.showLogo,
    required this.actions,
  });

  final String? title;
  final bool showLogo;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          if (showLogo) ...[
            const PromooLogo.compact(width: 32, height: 32),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (title != null)
            Expanded(
              child: Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          else
            const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
