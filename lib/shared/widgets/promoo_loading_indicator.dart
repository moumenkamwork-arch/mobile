import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class PromooLoadingIndicator extends StatelessWidget {
  const PromooLoadingIndicator({
    super.key,
    this.message,
    this.semanticLabel = 'Loading',
  });

  final String? message;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: semanticLabel,
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
