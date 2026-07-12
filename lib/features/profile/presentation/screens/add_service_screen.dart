import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../widgets/add_category_label.dart';

/// "Add New Service" single-page creation form.
///
/// Fields map 1:1 to the backend `POST /services` payload (title / description /
/// price / delivery_days / category_id / images / tags) so wiring the real
/// request during integration is a drop-in change.
/// Phase A: local-only, no network call.
class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _category;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _deliveryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooSubpageScaffold(
      title: l10n.menuAddService,
      bottomBar: _FormActions(
        submitLabel: l10n.addServiceCreateButton,
        onSubmit: _createService,
        onCancel: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            title: l10n.addServiceDetailsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(l10n.addCommonTitleLabel),
                PromooTextField(
                  controller: _titleController,
                  hint: l10n.addServiceTitleHint,
                  textInputAction: TextInputAction.next,
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addCommonDescriptionLabel),
                PromooTextField(
                  controller: _descriptionController,
                  hint: l10n.addServiceDescriptionHint,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addCommonCategoryLabel),
                _PickerField(
                  hint: _category == null
                      ? l10n.commonSelectCategory
                      : addCategoryLabel(context, _category!),
                  isPlaceholder: _category == null,
                  trailing: Icons.keyboard_arrow_down_rounded,
                  onTap: _pickCategory,
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addCommonTagsLabel),
                PromooTextField(
                  controller: _tagsController,
                  hint: l10n.addCommonTagsHint,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.addServicePricingTitle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel(l10n.commonPrice),
                      PromooTextField(
                        controller: _priceController,
                        hint: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffixIcon: const _Adornment('AED'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel(l10n.addServiceDeliveryLabel),
                      PromooTextField(
                        controller: _deliveryController,
                        hint: l10n.addServiceDeliveryHint,
                        keyboardType: TextInputType.number,
                        suffixIcon: _Adornment(l10n.addServiceDaysSuffix),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.profileMediaTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(l10n.addServiceImagesLabel),
                _UploadBox(
                  icon: Icons.add_photo_alternate_outlined,
                  label: l10n.addServiceUploadImages,
                  caption: l10n.addCommonUploadCaption,
                  onTap: _showUploadNotice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCategory() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.elevatedSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                child: Text(
                  l10n.commonSelectCategory,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              for (final option in addCategoryValues)
                ListTile(
                  title: Text(addCategoryLabel(sheetContext, option)),
                  trailing: option == _category
                      ? Icon(
                          Icons.check_rounded,
                          color: sheetContext.colors.accent,
                        )
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      setState(() => _category = selected);
    }
  }

  void _showUploadNotice() {
    _showNotice(AppLocalizations.of(context).addCommonMediaUploadComingSoon);
  }

  void _createService() {
    _showNotice(AppLocalizations.of(context).addServiceReadySnackbar);
    Navigator.of(context).maybePop();
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({
    required this.submitLabel,
    required this.onSubmit,
    required this.onCancel,
  });

  final String submitLabel;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PromooButton.primary(
          label: submitLabel,
          fullWidth: true,
          onPressed: onSubmit,
        ),
        const SizedBox(height: AppSpacing.xs),
        PromooButton.secondary(
          label: AppLocalizations.of(context).addCommonCancelButton,
          fullWidth: true,
          onPressed: onCancel,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _FieldGap extends StatelessWidget {
  const _FieldGap();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: AppSpacing.md);
  }
}

class _Adornment extends StatelessWidget {
  const _Adornment(this.symbol);

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

class _UploadBox extends StatelessWidget {
  const _UploadBox({
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

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.hint,
    required this.trailing,
    required this.onTap,
    this.isPlaceholder = true,
  });

  final String hint;
  final IconData trailing;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.input,
      child: InputDecorator(
        decoration: const InputDecoration(),
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
