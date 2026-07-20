import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../widgets/add_category_label.dart';
import '../widgets/add_form_widgets.dart';

/// "Add New Offer" single-page creation form.
///
/// Fields map 1:1 to the backend `POST /offers` payload (title / description /
/// original_price / offer_price / discount_percentage / category_id /
/// start_date / end_date / main_image / images / tags) so wiring the real
/// request during integration is a drop-in change.
/// Phase A: local-only, no network call.
class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _category;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _offerPriceController.dispose();
    _discountController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooSubpageScaffold(
      title: l10n.menuAddOffer,
      bottomBar: _FormActions(
        submitLabel: l10n.addOfferCreateButton,
        onSubmit: _createOffer,
        onCancel: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddFormSectionCard(
            title: l10n.addOfferDetailsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddFormFieldLabel(l10n.addCommonTitleLabel),
                PromooTextField(
                  controller: _titleController,
                  hint: l10n.addOfferTitleHint,
                  textInputAction: TextInputAction.next,
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonDescriptionLabel),
                PromooTextField(
                  controller: _descriptionController,
                  hint: l10n.addOfferDescriptionHint,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonCategoryLabel),
                AddFormPickerField(
                  hint: _category == null
                      ? l10n.commonSelectCategory
                      : addCategoryLabel(context, _category!),
                  isPlaceholder: _category == null,
                  trailing: Icons.keyboard_arrow_down_rounded,
                  onTap: _pickCategory,
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonTagsLabel),
                PromooTextField(
                  controller: _tagsController,
                  hint: l10n.addCommonTagsHint,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AddFormSectionCard(
            title: l10n.addOfferPricingTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AddFormFieldLabel(l10n.addOfferOriginalPriceLabel),
                          PromooTextField(
                            controller: _originalPriceController,
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            suffixIcon: const AddFormAdornment('AED'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AddFormFieldLabel(l10n.addOfferOfferPriceLabel),
                          PromooTextField(
                            controller: _offerPriceController,
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            suffixIcon: const AddFormAdornment('AED'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addOfferDiscountLabel),
                PromooTextField(
                  controller: _discountController,
                  hint: l10n.addOfferDiscountOptionalHint,
                  keyboardType: TextInputType.number,
                  suffixIcon: const AddFormAdornment('%'),
                ),
                const SizedBox(height: AppSpacing.xs),
                _FieldNote(l10n.addOfferDiscountNote),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AddFormSectionCard(
            title: l10n.addOfferScheduleTitle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddFormFieldLabel(l10n.addOfferStartDateLabel),
                      AddFormPickerField(
                        hint: _startDate == null
                            ? l10n.addOfferSelectDate
                            : _formatDate(_startDate!),
                        isPlaceholder: _startDate == null,
                        trailing: Icons.calendar_month_rounded,
                        onTap: _pickStartDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddFormFieldLabel(l10n.addOfferEndDateLabel),
                      AddFormPickerField(
                        hint: _endDate == null
                            ? l10n.addOfferSelectDate
                            : _formatDate(_endDate!),
                        isPlaceholder: _endDate == null,
                        trailing: Icons.calendar_month_rounded,
                        onTap: _pickEndDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AddFormSectionCard(
            title: l10n.profileMediaTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddFormFieldLabel(l10n.addOfferMainImageLabel),
                AddFormUploadBox(
                  icon: Icons.add_photo_alternate_outlined,
                  label: l10n.addOfferUploadMainImage,
                  caption: l10n.addCommonUploadCaption,
                  onTap: _showUploadNotice,
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addOfferAdditionalImageLabel),
                AddFormUploadBox(
                  icon: Icons.add_photo_alternate_outlined,
                  label: l10n.addOfferUploadAdditionalImages,
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

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final first = _startDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? first,
      firstDate: first,
      lastDate: DateTime(first.year + 2),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _showUploadNotice() {
    _showNotice(AppLocalizations.of(context).addCommonMediaUploadComingSoon);
  }

  void _createOffer() {
    _showNotice(AppLocalizations.of(context).addOfferReadySnackbar);
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

class _FieldNote extends StatelessWidget {
  const _FieldNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.colors.textMuted),
    );
  }
}
