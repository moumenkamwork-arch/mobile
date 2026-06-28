import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

class AuthSocialLoginPreview extends StatelessWidget {
  const AuthSocialLoginPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Continue with account',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                icon: Icons.apple,
                onTap: () => _showComingSoon(context, 'Apple sign-in'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _SocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                onTap: () => _showComingSoon(context, 'Google sign-in'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _SocialButton(
                label: 'Facebook',
                icon: Icons.facebook,
                onTap: () => _showComingSoon(context, 'Facebook sign-in'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.card,
            child: Ink(
              height: AppSpacing.touchTarget,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.card,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String label) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text('$label coming soon')));
}
