import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_image_upload_field.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../ads/data/repositories/ads_repository_impl.dart';
import '../../../ads/domain/entities/ad_draft.dart';
import '../../../ads/domain/entities/ad_listing.dart';
import '../../../upload/domain/entities/uploaded_media.dart';
import '../widgets/add_form_widgets.dart';

/// "Add New AD" 4-step wizard recreating the original app flow.
///
/// Steps and fields map 1:1 to the backend `POST /ads` payload
/// (`createAdSchema`): title/description/media/start_date/tags →
/// city/area/full_address/location_map_url → phone/whatsapp/contact_email/
/// instagram_link → price/currency/service_type/payment_method.
/// Phase A: local-only, no network call.
class AddAdWizardScreen extends ConsumerStatefulWidget {
  const AddAdWizardScreen({super.key, this.editing});

  /// When set, the wizard pre-fills from this existing ad and submits via
  /// `PUT /ads/:id` instead of `POST /ads`.
  final AdListing? editing;

  @override
  ConsumerState<AddAdWizardScreen> createState() => _AddAdWizardScreenState();
}

class _AddAdWizardScreenState extends ConsumerState<AddAdWizardScreen> {
  static const _cities = [
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Ras Al Khaimah',
    'Fujairah',
    'Umm Al Quwain',
    'Al Ain',
  ];

  static const _areasByCity = {
    'Dubai': ['Downtown', 'Marina', 'Jumeirah', 'Business Bay', 'Deira'],
    'Abu Dhabi': ['Corniche', 'Al Reem Island', 'Khalifa City', 'Yas Island'],
    'Sharjah': ['Al Majaz', 'Al Nahda', 'Muwaileh'],
    'Ajman': ['Al Nuaimiya', 'Corniche', 'Al Rashidiya'],
    'Ras Al Khaimah': ['Al Nakheel', 'Mina Al Arab'],
    'Fujairah': ['City Centre', 'Dibba'],
    'Umm Al Quwain': ['Old Town', 'Al Salamah'],
    'Al Ain': ['Central District', 'Al Jimi'],
  };

  static const _serviceTypes = ['Service', 'Product'];
  static const _currencies = ['AED'];
  static const _paymentMethods = ['Cash', 'Card', 'Bank Transfer'];

  int _step = 0;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = TextEditingController();

  DateTime? _postDate;
  String? _city;
  String? _area;
  String? _serviceType;
  String? _currency;
  String? _paymentMethod;
  String? _mainImageUrl;
  String? _locationMapUrl;
  bool _isSubmitting = false;

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
    _addressController.text = editing.fullAddress ?? '';
    _phoneController.text = editing.phone ?? '';
    _whatsappController.text = editing.whatsapp ?? '';
    _emailController.text = editing.contactEmail ?? '';
    _instagramController.text = editing.instagramLink ?? '';
    _priceController.text = editing.price == null ? '' : _formatNum(editing.price!);
    _tagsController.text = editing.tags.join(', ');
    _postDate = editing.startDate;
    _city = editing.city;
    _area = editing.area;
    _serviceType = editing.serviceType;
    _currency = editing.currency;
    _paymentMethod = editing.paymentMethod;
    _mainImageUrl = editing.mediaUrl.isEmpty ? null : editing.mediaUrl;
    _locationMapUrl = editing.locationMapUrl;
  }

  static String _formatNum(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _priceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  static String _cityLabel(BuildContext context, String city) {
    final l10n = AppLocalizations.of(context);
    return switch (city) {
      'Dubai' => l10n.addAdCityDubai,
      'Abu Dhabi' => l10n.addAdCityAbuDhabi,
      'Sharjah' => l10n.addAdCitySharjah,
      'Ajman' => l10n.addAdCityAjman,
      'Ras Al Khaimah' => l10n.addAdCityRasAlKhaimah,
      'Fujairah' => l10n.addAdCityFujairah,
      'Umm Al Quwain' => l10n.addAdCityUmmAlQuwain,
      'Al Ain' => l10n.addAdCityAlAin,
      _ => city,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stepTitles = [
      l10n.addAdStepBasic,
      l10n.addAdStepLocation,
      l10n.addAdStepContact,
      l10n.addAdStepPricing,
    ];
    return PromooSubpageScaffold(
      title: _isEditing ? l10n.addAdEditTitle : l10n.addAdScreenTitle,
      bottomBar: _WizardActions(
        step: _step,
        isSubmitting: _isSubmitting,
        isEditing: _isEditing,
        onBack: () {
          if (_step == 0) {
            Navigator.of(context).maybePop();
          } else {
            setState(() => _step -= 1);
          }
        },
        onNext: () {
          if (_step < 3) {
            setState(() => _step += 1);
          } else {
            _submit();
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepIndicator(current: _step, total: stepTitles.length),
          const SizedBox(height: AppSpacing.lg),
          AddFormSectionCard(
            title: stepTitles[_step],
            child: switch (_step) {
              0 => _buildBasicStep(l10n),
              1 => _buildLocationStep(l10n),
              2 => _buildContactStep(l10n),
              _ => _buildPricingStep(l10n),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBasicStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddFormFieldLabel(l10n.addAdTitleLabel),
        PromooTextField(
          controller: _titleController,
          hint: l10n.addAdTitleLabel,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addCommonDescriptionLabel),
        PromooTextField(
          controller: _descriptionController,
          hint: l10n.addCommonDescriptionLabel,
        ),
        const AddFormFieldGap(),
        // An ad carries a single `media_url` (not an array like offers/
        // services), so one image field here — required.
        AddFormFieldLabel(l10n.addOfferMainImageLabel),
        PromooImageUploadField(
          value: _mainImageUrl,
          onChanged: (url) => setState(() => _mainImageUrl = url),
          bucket: UploadBucket.ads,
          relatedTo: UploadRelatedTo.ad,
          label: l10n.addAdUploadImagesLabel,
          caption: l10n.addCommonUploadCaption,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdPostDateLabel),
        AddFormPickerField(
          hint: _postDate == null
              ? l10n.addAdSelectDateCap
              : '${_postDate!.year}-${_postDate!.month.toString().padLeft(2, '0')}-${_postDate!.day.toString().padLeft(2, '0')}',
          isPlaceholder: _postDate == null,
          trailing: Icons.calendar_month_rounded,
          onTap: _pickDate,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addCommonTagsLabel),
        PromooTextField(controller: _tagsController, hint: l10n.addAdTagsHint),
      ],
    );
  }

  Widget _buildLocationStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddFormFieldLabel(l10n.addAdCityLabel),
        _DropdownField(
          hint: l10n.addAdSelectCity,
          value: _city == null ? null : _cityLabel(context, _city!),
          items: [for (final city in _cities) _cityLabel(context, city)],
          onChanged: (label) => setState(() {
            _city = label == null
                ? null
                : _cities.firstWhere((c) => _cityLabel(context, c) == label);
            _area = null;
          }),
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdAreaLabel),
        _DropdownField(
          hint: l10n.addAdSelectArea,
          value: _area,
          items: _areasByCity[_city] ?? const [],
          onChanged: (value) => setState(() => _area = value),
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdFullAddressLabel),
        PromooTextField(
          controller: _addressController,
          hint: l10n.addAdFullAddressHint,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdLocationMapLabel),
        PromooImageUploadField(
          value: _locationMapUrl,
          onChanged: (url) => setState(() => _locationMapUrl = url),
          bucket: UploadBucket.ads,
          relatedTo: UploadRelatedTo.ad,
          icon: Icons.map_outlined,
          label: l10n.addAdUploadLocationMap,
          caption: l10n.addAdLocationMapCaption,
        ),
      ],
    );
  }

  Widget _buildContactStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddFormFieldLabel(l10n.addAdPhoneLabel),
        PromooTextField(
          controller: _phoneController,
          hint: l10n.addAdPhoneLabel,
          keyboardType: TextInputType.phone,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdWhatsappLabel),
        PromooTextField(
          controller: _whatsappController,
          hint: l10n.addAdWhatsappLabel,
          keyboardType: TextInputType.phone,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.authFieldEmail),
        PromooTextField(
          controller: _emailController,
          hint: l10n.authFieldEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdInstagramLabel),
        PromooTextField(
          controller: _instagramController,
          hint: l10n.addAdInstagramLabel,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildPricingStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddFormFieldLabel(l10n.commonPrice),
        PromooTextField(
          controller: _priceController,
          hint: l10n.commonPrice,
          keyboardType: TextInputType.number,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdCurrencyLabel),
        _DropdownField(
          hint: l10n.addAdSelectCurrency,
          value: _currency,
          items: _currencies,
          onChanged: (value) => setState(() => _currency = value),
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdServiceProductLabel),
        _DropdownField(
          hint: l10n.addAdSelectType,
          value: _serviceType,
          items: _serviceTypes,
          onChanged: (value) => setState(() => _serviceType = value),
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addAdPaymentMethodLabel),
        _DropdownField(
          hint: l10n.addAdSelectPaymentMethod,
          value: _paymentMethod,
          items: _paymentMethods,
          onChanged: (value) => setState(() => _paymentMethod = value),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _postDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _postDate = picked);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    final mainImage = _mainImageUrl;
    final price = num.tryParse(_priceController.text.trim());

    // `createAdSchema`: title >= 3 and media_url required. ad_type/budget are
    // schema-required with no MVP field — see AdDraft (defaults). A missing
    // image is the one thing worth blocking on here.
    if (title.length < 3 || mainImage == null || mainImage.isEmpty) {
      _showNotice(l10n.addCommonValidationTitle);
      if (mainImage == null || mainImage.isEmpty) {
        setState(() => _step = 0); // jump back to the step with the image
      }
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList(growable: false);

    final draft = AdDraft(
      title: title,
      mediaUrl: mainImage,
      adType: widget.editing?.adType ?? 'banner',
      // Nominal in v1 (no ad payment; admin activates the pending ad) —
      // proxy the entered price, fall back to 1 to satisfy `.positive()`.
      budget: (price != null && price > 0) ? price : 1,
      startDate: _postDate ?? DateTime.now(),
      description: _descriptionController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      contactEmail: _emailController.text.trim(),
      instagramLink: _instagramController.text.trim(),
      city: _city,
      area: _area,
      fullAddress: _addressController.text.trim(),
      locationMapUrl: _locationMapUrl,
      price: price,
      currency: _currency,
      serviceType: _serviceType,
      paymentMethod: _paymentMethod,
      tags: tags,
    );

    setState(() => _isSubmitting = true);
    final repository = ref.read(adsRepositoryProvider);
    final editingId = widget.editing?.id;
    final AppFailure? failure;
    if (editingId == null) {
      final result = await repository.createAd(draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    } else {
      final result = await repository.updateAd(editingId, draft);
      failure = result.when(success: (_) => null, failure: (f) => f);
    }
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);

    if (failure == null) {
      _showNotice(_isEditing ? l10n.addAdUpdated : l10n.addAdPublished);
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < total; i++) {
      children.add(_StepDot(state: _stateFor(i)));
      if (i < total - 1) {
        children.add(Expanded(child: _DashedConnector(done: i < current)));
      }
    }
    return Row(children: children);
  }

  _StepState _stateFor(int index) {
    if (index < current) {
      return _StepState.done;
    }
    if (index == current) {
      return _StepState.active;
    }
    return _StepState.pending;
  }
}

enum _StepState { done, active, pending }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.state});

  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;
    final colors = context.colors;

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isDone ? colors.primaryYellow : colors.textPrimary,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone || isActive ? colors.accent : colors.borderStrong,
          width: isActive ? 3 : 1,
        ),
      ),
      child: isDone
          ? const Icon(
              Icons.check_rounded,
              color: AppColors.brandBlack,
              size: 20,
            )
          : null,
    );
  }
}

class _DashedConnector extends StatelessWidget {
  const _DashedConnector({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 6.0;
          const gap = 5.0;
          final count = (constraints.maxWidth / (dashWidth + gap)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < count; i++)
                Container(
                  width: dashWidth,
                  height: 2,
                  color: done
                      ? context.colors.accent
                      : context.colors.borderStrong,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _WizardActions extends StatelessWidget {
  const _WizardActions({
    required this.step,
    required this.onBack,
    required this.onNext,
    this.isSubmitting = false,
    this.isEditing = false,
  });

  final int step;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isSubmitting;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final finalStepLabel = isEditing
        ? l10n.addCommonSaveButton
        : l10n.addAdCreateButton;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.error,
              side: BorderSide(color: context.colors.error),
            ),
            child: Text(
              step == 0 ? l10n.addCommonCancelButton : l10n.commonBack,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PromooButton.primary(
            label: isSubmitting
                ? (isEditing ? l10n.addCommonSaving : l10n.addCommonPublishing)
                : (step == 3 ? finalStepLabel : l10n.addAdNextButton),
            fullWidth: true,
            onPressed: isSubmitting ? null : onNext,
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      hint: Text(
        hint,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: context.colors.textSecondary),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.textSecondary,
      ),
      dropdownColor: context.colors.elevatedSurface,
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(item)),
      ],
      onChanged: onChanged,
    );
  }
}
