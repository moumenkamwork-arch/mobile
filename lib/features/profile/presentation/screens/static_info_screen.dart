import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_spacing.dart';

/// Static legal/informational pages linked from the Profile footer:
/// About, Terms & Conditions, and Privacy Policy.
class StaticInfoScreen extends StatelessWidget {
  const StaticInfoScreen({super.key, required this.topic});

  final String topic;

  static const _content = {
    'about': (
      title: 'About',
      body:
          'Promoo is a premium marketplace connecting companies, influencers, '
          'and service providers across the UAE.\n\n'
          'Discover offers, book influencer seats, promote your brand, and '
          'grow your reach — all in one place, in AED.',
    ),
    'terms': (
      title: 'Terms And Condition',
      body:
          'By using Promoo you agree to use the platform fairly and lawfully.\n\n'
          '• Content you publish must be accurate and owned by you.\n'
          '• Paid placements (seats, featured offers) follow the posted '
          'pricing at the time of purchase.\n'
          '• Accounts that violate our community standards may be suspended.\n\n'
          'The full legal terms will be published here before the public '
          'store release.',
    ),
    'privacy': (
      title: 'Privacy Policy',
      body:
          'Your privacy matters to Promoo.\n\n'
          '• We only collect the data needed to run your account and show '
          'relevant content.\n'
          '• Your data is never sold to third parties.\n'
          '• You can request account deletion at any time.\n\n'
          'The full privacy policy will be published here before the public '
          'store release.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final content = _content[topic] ?? _content['about']!;

    return PromooSubpageScaffold(
      title: content.title,
      child: PromooCard(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: Text(
          content.body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      ),
    );
  }
}
