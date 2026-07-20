import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/auth_session.dart';

class AuthSignedInPanel extends StatelessWidget {
  const AuthSignedInPanel({
    super.key,
    required this.session,
    required this.isLoggingOut,
    required this.onLogout,
  });

  final AuthSession session;
  final bool isLoggingOut;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: context.colors.primaryYellow,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.authSignedInTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            session.user.displayName,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: l10n.authContinue,
            icon: Icons.arrow_forward_rounded,
            fullWidth: true,
            onPressed: () => context.go(AppRoutes.home),
          ),
          const SizedBox(height: AppSpacing.sm),
          PromooButton.secondary(
            label: isLoggingOut ? l10n.authSigningOut : l10n.authSignOut,
            icon: Icons.logout_rounded,
            fullWidth: true,
            onPressed: isLoggingOut ? null : onLogout,
          ),
        ],
      ),
    );
  }
}
