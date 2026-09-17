import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_profile.dart';

class ProfileAboutSection extends StatelessWidget {
  const ProfileAboutSection({super.key, required this.profile});

  final PromooProfile profile;

  @override
  Widget build(BuildContext context) {
    final website = profile.website;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromooSectionHeader(title: l10n.profileAboutTitle),
        const SizedBox(height: AppSpacing.md),
        PromooCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.bio ?? l10n.profileAboutFallback,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (website != null) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.link_rounded, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        website,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
