import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../widgets/add_form_widgets.dart';

/// "Add New AD" 4-step wizard recreating the original app flow.
///
/// Steps and fields map 1:1 to the backend `POST /ads` payload
/// (`createAdSchema`): title/description/media/start_date/tags →
/// city/area/full_address/location_map_url → phone/whatsapp/contact_email/
/// instagram_link → price/currency/service_type/payment_method.
/// Phase A: local-only, no network call.
class AddAdWizardScreen extends StatefulWidget {
  const AddAdWizardScreen({super.key});

  @override
  State<AddAdWizardScreen> createState() => _AddAdWizardScreenState();
}

class _AddAdWizardScreenState extends State<AddAdWizardScreen> {
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
      title: l10n.addAdScreenTitle,
      bottomBar: _WizardActions(
        step: _step,
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
            _createAd();
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
        AddFormFieldLabel(l10n.addOfferMainImageLabel),
        AddFormUploadBox(
          icon: Icons.add_photo_alternate_outlined,
          label: l10n.addAdUploadImagesLabel,
          caption: l10n.addCommonUploadCaption,
          onTap: _showUploadNotice,
        ),
        const AddFormFieldGap(),
        AddFormFieldLabel(l10n.addOfferAdditionalImageLabel),
        AddFormUploadBox(
          icon: Icons.add_photo_alternate_outlined,
          label: l10n.addAdUploadImagesLabel,
          caption: l10n.addCommonUploadCaption,
          onTap: _showUploadNotice,
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
        AddFormUploadBox(
          icon: Icons.map_outlined,
          label: l10n.addAdUploadLocationMap,
          caption: l10n.addAdLocationMapCaption,
          onTap: _showUploadNotice,
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

  void _showUploadNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).addCommonMediaUploadComingSoon,
          ),
        ),
      );
  }

  void _createAd() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).addAdReadySnackbar),
        ),
      );
    Navigator.of(context).maybePop();
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
  });

  final int step;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBack,
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
            label: step == 3 ? l10n.addAdCreateButton : l10n.addAdNextButton,
            fullWidth: true,
            onPressed: onNext,
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
