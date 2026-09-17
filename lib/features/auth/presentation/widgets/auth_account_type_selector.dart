import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/auth_session.dart';

/// Resolves the localized label for an [AuthAccountType]. A free function
/// (not a domain-entity getter) because domain code must stay Flutter-free.
String authAccountTypeLabel(BuildContext context, AuthAccountType type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    AuthAccountType.user => l10n.authAccountTypeUser,
    AuthAccountType.company => l10n.authAccountTypeCompany,
    AuthAccountType.influencer => l10n.authAccountTypeInfluencer,
    AuthAccountType.serviceProvider => l10n.authAccountTypeServiceProvider,
  };
}

class AuthAccountTypeSelector extends StatelessWidget {
  const AuthAccountTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AuthAccountType selected;
  final ValueChanged<AuthAccountType> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final type in AuthAccountType.values)
          ChoiceChip(
            label: Text(authAccountTypeLabel(context, type)),
            selected: selected == type,
            selectedColor: colors.primaryYellow,
            backgroundColor: colors.surface,
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected == type
                  ? AppColors.brandBlack
                  : colors.textPrimary,
            ),
            side: BorderSide(
              color: selected == type ? colors.primaryYellow : colors.border,
            ),
            onSelected: (_) => onSelected(type),
          ),
      ],
    );
  }
}
