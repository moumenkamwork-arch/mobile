import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

/// "MyPackages" page recreating the original Packages screen.
///
/// Display-only in v1: the backend has no content-package entity yet
/// (see docs/v2_deferred_scope.md — Payments §2), so the checkout line
/// shows a safe notice instead of starting a payment.
class MyPackagesScreen extends StatelessWidget {
  const MyPackagesScreen({super.key});

  static const _packages = [
    (title: 'Basic Package', price: '99.0 AED', posts: 'Includes 3 posts'),
    (title: 'Standard Package', price: '149.0 AED', posts: 'Includes 6 posts'),
    (title: 'Premium Package', price: '249.0 AED', posts: 'Includes 12 posts'),
  ];

  @override
  Widget build(BuildContext context) {
    return PromooSubpageScaffold(
      title: 'Packages',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final package in _packages) ...[
            _PackageCard(
              title: package.title,
              price: package.price,
              posts: package.posts,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.title,
    required this.price,
    required this.posts,
  });

  final String title;
  final String price;
  final String posts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    // Gold ink in light mode, brand yellow on black — same premium accent.
    final yellowTitle = theme.textTheme.titleLarge?.copyWith(
      color: colors.accent,
      fontWeight: FontWeight.w800,
      fontSize: 24,
    );

    return InkWell(
      onTap: () => _showCheckoutNotice(context),
      borderRadius: AppRadius.card,
      child: Container(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.background.withValues(alpha: 0.55),
          borderRadius: AppRadius.card,
          border: Border.all(color: colors.accent.withValues(alpha: 0.85)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(title, style: yellowTitle)),
                Text(
                  price,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
            Text(
              posts,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            const _Bullet('Professionally designed social media posts'),
            const _Bullet('High-quality content tailored to your brand'),
            const _Bullet('Guaranteed fast delivery within 24 hours'),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Guarantee:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.accent,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            const _Bullet(
              'Trust that your content will reach more than 1,000 people.',
            ),
            const _Bullet(
              'Your engagement and visibility are our top priority.',
            ),
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
            Center(
              child: Text(
                'Tap to view details and proceed to secure checkout.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.accent.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutNotice(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Package checkout will be available in the next phase.',
          ),
        ),
      );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
