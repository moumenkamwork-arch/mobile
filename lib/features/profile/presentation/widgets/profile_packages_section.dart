import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_section_header.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_profile.dart';
import 'profile_package_card.dart';

class ProfilePackagesSection extends StatelessWidget {
  const ProfilePackagesSection({super.key, required this.packages});

  final List<ProfilePackage> packages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromooSectionHeader(
          title: l10n.profilePackagesTitle,
          subtitle: l10n.profilePackagesSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (packages.isEmpty)
          PromooEmptyState(
            title: l10n.profilePackagesEmptyTitle,
            message: l10n.profilePackagesEmptyMessage,
            icon: Icons.local_offer_rounded,
          )
        else
          for (var i = 0; i < packages.length; i++) ...[
            ProfilePackageCard(package: packages[i]),
            if (i != packages.length - 1) const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }
}
