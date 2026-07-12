import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_spacing.dart';

/// Static legal/informational pages linked from the Profile footer:
/// About, Terms & Conditions, and Privacy Policy.
class StaticInfoScreen extends StatelessWidget {
  const StaticInfoScreen({super.key, required this.topic});

  final String topic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = {
      'about': (title: l10n.footerAbout, body: l10n.staticInfoAboutBody),
      'terms': (
        title: l10n.staticInfoTermsTitle,
        body: l10n.staticInfoTermsBody,
      ),
      'privacy': (title: l10n.footerPrivacy, body: l10n.staticInfoPrivacyBody),
    };
    final selected = content[topic] ?? content['about']!;

    return PromooSubpageScaffold(
      title: selected.title,
      child: PromooCard(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        child: Text(
          selected.body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      ),
    );
  }
}
