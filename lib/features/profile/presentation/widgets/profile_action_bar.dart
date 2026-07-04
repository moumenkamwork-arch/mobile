import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../theme/app_spacing.dart';

class ProfileActionBar extends StatelessWidget {
  const ProfileActionBar({
    super.key,
    required this.isOwner,
    required this.onFollowPressed,
    required this.onMessagePressed,
    required this.onEditPressed,
  });

  final bool isOwner;
  final VoidCallback onFollowPressed;
  final VoidCallback onMessagePressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    if (isOwner) {
      return PromooButton.secondary(
        label: 'Edit profile',
        icon: Icons.edit_rounded,
        onPressed: onEditPressed,
        fullWidth: true,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PromooButton.primary(
                label: 'Follow',
                icon: Icons.person_add_alt_1_rounded,
                onPressed: onFollowPressed,
                fullWidth: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PromooButton.secondary(
                label: 'Message',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: onMessagePressed,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
