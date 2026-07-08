import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/auth_session.dart';

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
            label: Text(type.label),
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
