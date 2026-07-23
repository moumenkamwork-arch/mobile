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
import '../../../services/data/repositories/services_repository_impl.dart';
import '../../../services/domain/entities/promoo_service.dart';
import '../../../services/presentation/controllers/service_categories_provider.dart';
import '../../../upload/domain/entities/uploaded_media.dart';
import '../widgets/add_form_widgets.dart';

/// "Add New Service" — collects the `POST /services` fields, uploads an image
/// through the shared Upload infra, then publishes (role-gated to
/// service_provider/company by the backend).
class AddServiceScreen extends ConsumerStatefulWidget {
  const AddServiceScreen({super.key, this.editing});

  /// When set, the form pre-fills from this existing service and submits via
  /// `PUT /services/:id` instead of `POST /services`.
  final PromooService? editing;

  @override
  ConsumerState<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends ConsumerState<AddServiceScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _tagsController = TextEditingController();

  ServiceCategory? _category;
  String? _imageUrl;
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
    _descriptionController.text = editing.description ?? '';
    _priceController.text = editing.price == null
        ? ''
        : _formatNum(editing.price!.amount);
    _deliveryController.text = editing.deliveryDays?.toString() ?? '';
    _tagsController.text = editing.tags.join(', ');
    _category = editing.category;
    if (editing.imageUrls.isNotEmpty) {
      _imageUrl = editing.imageUrls.first;
    }
  }

  static String _formatNum(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

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
    ref.watch(serviceCategoriesProvider);

    return PromooSubpageScaffold(
      title: _isEditing ? l10n.addServiceEditTitle : l10n.menuAddService,
      bottomBar: _FormActions(
        submitLabel: _isSubmitting
            ? (_isEditing ? l10n.addCommonSaving : l10n.addCommonPublishing)
            : (_isEditing
                  ? l10n.addCommonSaveButton
                  : l10n.addServiceCreateButton),
        onSubmit: _isSubmitting ? null : _submit,
        onCancel: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddFormSectionCard(
            title: l10n.addServiceDetailsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddFormFieldLabel(l10n.addCommonTitleLabel),
                PromooTextField(
                  controller: _titleController,
                  hint: l10n.addServiceTitleHint,
                  textInputAction: TextInputAction.next,
                  isError: _hasSubmitted && _titleController.text.trim().length < 5,
                  onChanged: (_) => setState(() {}),
                ),
                const AddFormFieldGap(),
                AddFormFieldLabel(l10n.addCommonDescriptionLabel),
                PromooTextField(
                  controller: _descriptionController,
                  hint: l10n.addServiceDescriptionHint,
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
            title: l10n.addServicePricingTitle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddFormFieldLabel(l10n.commonPrice),
                      PromooTextField(
                        controller: _priceController,
                        hint: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffixIcon: const AddFormAdornment('AED'),
                        isError: _hasSubmitted &&
                            (num.tryParse(_priceController.text.trim()) == null ||
                                num.tryParse(_priceController.text.trim())! <= 0),
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
                      AddFormFieldLabel(l10n.addServiceDeliveryLabel),
                      PromooTextField(
                        controller: _deliveryController,
                        hint: l10n.addServiceDeliveryHint,
                        keyboardType: TextInputType.number,
                        suffixIcon: AddFormAdornment(l10n.addServiceDaysSuffix),
                        isError: _hasSubmitted &&
                            (int.tryParse(_deliveryController.text.trim()) == null ||
                                int.tryParse(_deliveryController.text.trim())! <= 0),
                        onChanged: (_) => setState(() {}),
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
                AddFormFieldLabel(l10n.addServiceImagesLabel),
                PromooImageUploadField(
                  value: _imageUrl,
                  onChanged: (url) => setState(() => _imageUrl = url),
                  bucket: UploadBucket.services,
                  relatedTo: UploadRelatedTo.service,
                  label: l10n.addServiceUploadImages,
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

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final category = _category;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final price = num.tryParse(_priceController.text.trim());
    final deliveryDays = int.tryParse(_deliveryController.text.trim());

    setState(() => _hasSubmitted = true);

    // Mirror `createServiceSchema`: title >= 5, description >= 10, price > 0,
    // delivery_days a positive int, category required.
    if (category == null ||
        title.length < 5 ||
        description.length < 10 ||
        price == null ||
        price <= 0 ||
        deliveryDays == null ||
        deliveryDays <= 0) {
      _showNotice(l10n.addCommonValidationTitle);
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList(growable: false);

    final draft = ServiceDraft(
      categoryId: category.id,
      title: title,
      description: description,
      price: price,
      deliveryDays: deliveryDays,
      mediaUrls: [?_imageUrl],
      tags: tags,
    );

    setState(() => _isSubmitting = true);
    final repository = ref.read(servicesRepositoryProvider);
    final editingId = widget.editing?.id;
    final AppFailure? failure;
    if (editingId == null) {
      final result = await repository.createService(draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    } else {
      final result = await repository.updateService(editingId, draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    }
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);

    if (failure == null) {
      _showNotice(_isEditing ? l10n.addServiceUpdated : l10n.addServicePublished);
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
