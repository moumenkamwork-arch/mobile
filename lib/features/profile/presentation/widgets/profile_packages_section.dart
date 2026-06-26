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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PromooSectionHeader(
          title: 'Packages',
          subtitle: 'Profile services for display and contact only',
        ),
        const SizedBox(height: AppSpacing.md),
        if (packages.isEmpty)
          const PromooEmptyState(
            title: 'No packages yet',
            message: 'Profile packages will appear here when available.',
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
