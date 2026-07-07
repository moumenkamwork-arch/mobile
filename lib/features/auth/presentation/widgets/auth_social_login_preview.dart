import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// Social sign-in row shown on Login/Register.
///
/// v1 scope: these are safe visual placeholders only, deferred to v2 (see
/// docs/v2_deferred_scope.md §1). Facebook is not shown: the backend never
/// supported it (Supabase OAuth is Google/Apple only).
class AuthSocialLoginPreview extends StatelessWidget {
  const AuthSocialLoginPreview({
    super.key,
    this.caption = 'Log in with account',
  });

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialCircle(
              label: 'Apple',
              icon: Icons.apple,
              iconColor: AppColors.textPrimary,
              background: const Color(0xFF3A3A3A),
              onTap: () => _showComingSoon(context, 'Apple sign-in'),
            ),
            const SizedBox(width: AppSpacing.lg),
            _SocialCircle(
              label: 'Google',
              iconWidget: SvgPicture.asset(
                'assets/brand/social/google_g.svg',
                width: 26,
                height: 26,
              ),
              background: const Color(0xFF3A3A3A),
              onTap: () => _showComingSoon(context, 'Google sign-in'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({
    required this.label,
    required this.background,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.iconWidget,
  }) : assert(
         icon != null || iconWidget != null,
         'Provide either icon or iconWidget',
       );

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Widget? iconWidget;
  final Color background;
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
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: iconWidget ?? Icon(icon, color: iconColor, size: 28),
              ),
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
