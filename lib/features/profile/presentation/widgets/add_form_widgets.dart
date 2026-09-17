import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

/// Shared chrome for the "Add Offer" / "Add Service" / "Add Ad" forms:
/// section card, field label/gap, upload box, picker field, and a price
/// suffix adornment. Kept feature-local (not in lib/shared/widgets/) since
/// only these three forms use them.
class AddFormSectionCard extends StatelessWidget {
  const AddFormSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.cardSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class AddFormFieldLabel extends StatelessWidget {
  const AddFormFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class AddFormFieldGap extends StatelessWidget {
  const AddFormFieldGap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: AppSpacing.md);
  }
}

class AddFormAdornment extends StatelessWidget {
  const AddFormAdornment(this.symbol, {super.key});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
      child: Center(
        widthFactor: 1,
        child: Text(
          symbol,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class AddFormUploadBox extends StatelessWidget {
  const AddFormUploadBox({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: context.colors.borderStrong),
        ),
        child: Column(
          children: [
            Icon(icon, color: context.colors.textSecondary, size: 30),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xxs),
            Text(caption, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class AddFormPickerField extends StatelessWidget {
  const AddFormPickerField({
    super.key,
    required this.hint,
    required this.trailing,
    required this.onTap,
    this.isPlaceholder = true,
    this.isError = false,
  });

  final String hint;
  final IconData trailing;
  final VoidCallback onTap;
  final bool isPlaceholder;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.input,
      child: InputDecorator(
        decoration: InputDecoration(
          enabledBorder: isError
              ? OutlineInputBorder(
                  borderRadius: AppRadius.input,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 1.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isPlaceholder
                      ? context.colors.textSecondary
                      : context.colors.textPrimary,
                ),
              ),
            ),
            Icon(trailing, color: context.colors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }
}
