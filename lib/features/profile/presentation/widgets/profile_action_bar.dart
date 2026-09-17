import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../theme/app_spacing.dart';

class ProfileActionBar extends StatelessWidget {
  const ProfileActionBar({
    super.key,
    required this.isOwner,
    required this.isFollowing,
    required this.onFollowPressed,
    required this.onMessagePressed,
    required this.onEditPressed,
  });

  final bool isOwner;
  final bool isFollowing;
  final VoidCallback onFollowPressed;
  final VoidCallback onMessagePressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isOwner) {
      return PromooButton.secondary(
        label: l10n.profileActionEditProfile,
        icon: Icons.edit_rounded,
        onPressed: onEditPressed,
        fullWidth: true,
      );
    }

    return Row(
      children: [
        Expanded(
          // Instagram-style toggle: filled "Follow" ↔ outlined "Following".
          child: isFollowing
              ? PromooButton.secondary(
                  label: l10n.profileActionFollowing,
                  icon: Icons.check_rounded,
                  onPressed: onFollowPressed,
                  fullWidth: true,
                )
              : PromooButton.primary(
                  label: l10n.profileActionFollow,
                  icon: Icons.person_add_alt_1_rounded,
                  onPressed: onFollowPressed,
                  fullWidth: true,
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: PromooButton.secondary(
            label: l10n.profileActionMessage,
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: onMessagePressed,
            fullWidth: true,
          ),
        ),
      ],
    );
  }
}
