import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_image_upload_field.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../offers/data/repositories/offers_repository_impl.dart';
import '../../../offers/domain/entities/offer_draft.dart';
import '../../../offers/domain/entities/offer_listing.dart';
import '../../../services/domain/entities/promoo_service.dart';
import '../../../services/presentation/controllers/service_categories_provider.dart';
import '../../../upload/domain/entities/uploaded_media.dart';
import '../widgets/add_form_widgets.dart';

/// "Add New Offer" — collects the `POST /offers` fields, uploads images through
/// the shared Upload infra, then publishes (role-gated to company/
/// service_provider by the backend; the menu entry is already hidden for
/// others via `accountCapabilities`).
class AddOfferScreen extends ConsumerStatefulWidget {
  const AddOfferScreen({super.key, this.editing});

  /// When set, the form pre-fills from this existing offer and submits via
  /// `PUT /offers/:id` instead of `POST /offers` — same screen, no separate
  /// edit form to maintain.
  final OfferListing? editing;

  @override
  ConsumerState<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends ConsumerState<AddOfferScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _tagsController = TextEditingController();

  ServiceCategory? _category;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _mainImageUrl;
  String? _additionalImageUrl;
  bool _isSubmitting = false;
  bool _hasSubmitted = false;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final editing = widget.editing;
    if (editing == null) {
      return;
    }
    _titleController.text = editing.title;
    _descriptionController.text = editing.description;
    _offerPriceController.text = _formatNum(editing.offerPrice);
    _originalPriceController.text = editing.originalPrice == null
        ? ''
        : _formatNum(editing.originalPrice!);
    _discountController.text = editing.discountPercentage?.toString() ?? '';
    _tagsController.text = editing.tags.join(', ');
    _startDate = editing.startDate;
    _endDate = editing.endDate;
    if (editing.categoryId != null) {
      _category = ServiceCategory(
        id: editing.categoryId!,
        name: editing.categoryName ?? '',
      );
    }
    if (editing.mediaUrls.isNotEmpty) {
      _mainImageUrl = editing.mediaUrls[0];
    }
    if (editing.mediaUrls.length > 1) {
      _additionalImageUrl = editing.mediaUrls[1];
    }
  }

  static String _formatNum(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

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
    // Keep the categories loaded so the picker has real data (and a real
    // category_id) when opened.
    ref.watch(serviceCategoriesProvider);

    return PromooSubpageScaffold(
      title: _isEditing ? l10n.addOfferEditTitle : l10n.menuAddOffer,
      bottomBar: _FormActions(
        submitLabel: _isSubmitting
            ? (_isEditing ? l10n.addCommonSaving : l10n.addCommonPublishing)
            : (_isEditing ? l10n.addCommonSaveButton : l10n.addOfferCreateButton),
        onSubmit: _isSubmitting ? null : _submit,
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
                  isError: _hasSubmitted && _titleController.text.trim().length < 3,
                  onChanged: (_) => setState(() {}),
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonDescriptionLabel),
                PromooTextField(
                  controller: _descriptionController,
                  hint: l10n.addOfferDescriptionHint,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  isError: _hasSubmitted && _descriptionController.text.trim().length < 10,
                  onChanged: (_) => setState(() {}),
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonCategoryLabel),
                AddFormPickerField(
                  hint: _category?.name ?? l10n.commonSelectCategory,
                  isPlaceholder: _category == null,
                  isError: _hasSubmitted && _category == null,
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
                            isError: _hasSubmitted &&
                                (num.tryParse(_originalPriceController.text.trim()) != null &&
                                    num.tryParse(_offerPriceController.text.trim()) != null &&
                                    num.tryParse(_offerPriceController.text.trim())! >=
                                        num.tryParse(_originalPriceController.text.trim())!),
                            onChanged: (_) => setState(() {}),
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
                            isError: _hasSubmitted &&
                                (num.tryParse(_offerPriceController.text.trim()) == null ||
                                    num.tryParse(_offerPriceController.text.trim())! <= 0 ||
                                    (num.tryParse(_originalPriceController.text.trim()) != null &&
                                        num.tryParse(_offerPriceController.text.trim())! >=
                                            num.tryParse(_originalPriceController.text.trim())!)),
                            onChanged: (_) => setState(() {}),
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
                PromooImageUploadField(
                  value: _mainImageUrl,
                  onChanged: (url) => setState(() => _mainImageUrl = url),
                  bucket: UploadBucket.offers,
                  relatedTo: UploadRelatedTo.offer,
                  label: l10n.addOfferUploadMainImage,
                  caption: l10n.addCommonUploadCaption,
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addOfferAdditionalImageLabel),
                PromooImageUploadField(
                  value: _additionalImageUrl,
                  onChanged: (url) => setState(() => _additionalImageUrl = url),
                  bucket: UploadBucket.offers,
                  relatedTo: UploadRelatedTo.offer,
                  label: l10n.addOfferUploadAdditionalImages,
                  caption: l10n.addCommonUploadCaption,
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
    final categories = ref.read(serviceCategoriesProvider).asData?.value;
    if (categories == null || categories.isEmpty) {
      _showNotice(l10n.addCommonCategoriesUnavailable);
      ref.invalidate(serviceCategoriesProvider);
      return;
    }

    final selected = await showModalBottomSheet<ServiceCategory>(
      context: context,
      backgroundColor: context.colors.elevatedSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
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
                for (final option in categories)
                  ListTile(
                    title: Text(option.name),
                    trailing: option.id == _category?.id
                        ? Icon(Icons.check_rounded, color: sheetContext.colors.accent)
                        : null,
                    onTap: () => Navigator.of(sheetContext).pop(option),
                  ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
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

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final category = _category;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final offerPrice = num.tryParse(_offerPriceController.text.trim());
    final originalPrice = num.tryParse(_originalPriceController.text.trim());
    final discount = int.tryParse(_discountController.text.trim());

    setState(() => _hasSubmitted = true);

    // Mirror `createOfferSchema` so we fail fast in the UI instead of on a 400.
    if (category == null ||
        title.length < 3 ||
        description.length < 10 ||
        offerPrice == null ||
        offerPrice <= 0 ||
        (originalPrice != null && offerPrice >= originalPrice)) {
      _showNotice(l10n.addCommonValidationTitle);
      return;
    }

    final mediaUrls = [
      ?_mainImageUrl,
      ?_additionalImageUrl,
    ];
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList(growable: false);

    final draft = OfferDraft(
      categoryId: category.id,
      title: title,
      description: description,
      offerPrice: offerPrice,
      startDate: _startDate ?? DateTime.now(),
      originalPrice: originalPrice,
      discountPercentage: discount,
      endDate: _endDate,
      mediaUrls: mediaUrls,
      tags: tags,
    );

    setState(() => _isSubmitting = true);
    final repository = ref.read(offersRepositoryProvider);
    final editingId = widget.editing?.id;
    final AppFailure? failure;
    if (editingId == null) {
      final result = await repository.createOffer(draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    } else {
      final result = await repository.updateOffer(editingId, draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    }
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);

    if (failure == null) {
      _showNotice(_isEditing ? l10n.addOfferUpdated : l10n.addOfferPublished);
      Navigator.of(context).maybePop();
    } else {
      _showNotice(l10n.addCommonSubmitFailed(failure.message));
    }
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
  final VoidCallback? onSubmit;
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
