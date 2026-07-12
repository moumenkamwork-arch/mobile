import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../widgets/add_category_label.dart';

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
          _SectionCard(
            title: l10n.addOfferDetailsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(l10n.addCommonTitleLabel),
                PromooTextField(
                  controller: _titleController,
                  hint: l10n.addOfferTitleHint,
                  textInputAction: TextInputAction.next,
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addCommonDescriptionLabel),
                PromooTextField(
                  controller: _descriptionController,
                  hint: l10n.addOfferDescriptionHint,
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
                          _FieldLabel(l10n.addOfferOriginalPriceLabel),
                          PromooTextField(
                            controller: _originalPriceController,
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
                          _FieldLabel(l10n.addOfferOfferPriceLabel),
                          PromooTextField(
                            controller: _offerPriceController,
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            suffixIcon: const _Adornment('AED'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addOfferDiscountLabel),
                PromooTextField(
                  controller: _discountController,
                  hint: l10n.addOfferDiscountOptionalHint,
                  keyboardType: TextInputType.number,
                  suffixIcon: const _Adornment('%'),
                ),
                const SizedBox(height: AppSpacing.xs),
                _FieldNote(l10n.addOfferDiscountNote),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.addOfferScheduleTitle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel(l10n.addOfferStartDateLabel),
                      _PickerField(
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
                      _FieldLabel(l10n.addOfferEndDateLabel),
                      _PickerField(
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
          _SectionCard(
            title: l10n.profileMediaTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(l10n.addOfferMainImageLabel),
                _UploadBox(
                  icon: Icons.add_photo_alternate_outlined,
                  label: l10n.addOfferUploadMainImage,
                  caption: l10n.addCommonUploadCaption,
                  onTap: _showUploadNotice,
                ),
                const _FieldGap(),
                _FieldLabel(l10n.addOfferAdditionalImageLabel),
                _UploadBox(
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
