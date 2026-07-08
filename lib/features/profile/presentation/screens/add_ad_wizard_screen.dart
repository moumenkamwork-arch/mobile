import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

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
  static const _stepTitles = [
    'Basic Ad Details',
    'Location Information',
    'Contact Information',
    'Pricing Information',
  ];

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

  @override
  Widget build(BuildContext context) {
    return PromooSubpageScaffold(
      title: 'Add New AD',
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
          _StepIndicator(current: _step, total: _stepTitles.length),
          const SizedBox(height: AppSpacing.lg),
          _WizardCard(
            title: _stepTitles[_step],
            child: switch (_step) {
              0 => _buildBasicStep(),
              1 => _buildLocationStep(),
              2 => _buildContactStep(),
              _ => _buildPricingStep(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBasicStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel('Ad Title'),
        PromooTextField(controller: _titleController, hint: 'Ad Title'),
        const _FieldGap(),
        const _FieldLabel('Description'),
        PromooTextField(
          controller: _descriptionController,
          hint: 'Description',
        ),
        const _FieldGap(),
        const _FieldLabel('Main Image'),
        _UploadBox(
          icon: Icons.add_photo_alternate_outlined,
          label: 'Upload additional images',
          caption: 'JPG, PNG up to 2MB',
          onTap: _showUploadNotice,
        ),
        const _FieldGap(),
        const _FieldLabel('Additional Image'),
        _UploadBox(
          icon: Icons.add_photo_alternate_outlined,
          label: 'Upload additional images',
          caption: 'JPG, PNG up to 2MB',
          onTap: _showUploadNotice,
        ),
        const _FieldGap(),
        const _FieldLabel('Post Date'),
        _PickerField(
          hint: _postDate == null
              ? 'Select Date'
              : '${_postDate!.year}-${_postDate!.month.toString().padLeft(2, '0')}-${_postDate!.day.toString().padLeft(2, '0')}',
          trailing: Icons.calendar_month_rounded,
          onTap: _pickDate,
        ),
        const _FieldGap(),
        const _FieldLabel('Tags'),
        PromooTextField(controller: _tagsController, hint: 'Add Tags'),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel('City'),
        _DropdownField(
          hint: 'Select City',
          value: _city,
          items: _cities,
          onChanged: (value) => setState(() {
            _city = value;
            _area = null;
          }),
        ),
        const _FieldGap(),
        const _FieldLabel('Area'),
        _DropdownField(
          hint: 'Select Area',
          value: _area,
          items: _areasByCity[_city] ?? const [],
          onChanged: (value) => setState(() => _area = value),
        ),
        const _FieldGap(),
        const _FieldLabel('full Address'),
        PromooTextField(controller: _addressController, hint: 'Full Address'),
        const _FieldGap(),
        const _FieldLabel('Location Map'),
        _UploadBox(
          icon: Icons.map_outlined,
          label: 'Upload Location Map',
          caption: 'Please upload location map',
          onTap: _showUploadNotice,
        ),
      ],
    );
  }

  Widget _buildContactStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel('Phone Number'),
        PromooTextField(
          controller: _phoneController,
          hint: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        const _FieldGap(),
        const _FieldLabel('Whatsapp Number'),
        PromooTextField(
          controller: _whatsappController,
          hint: 'Whatsapp Number',
          keyboardType: TextInputType.phone,
        ),
        const _FieldGap(),
        const _FieldLabel('Email'),
        PromooTextField(
          controller: _emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const _FieldGap(),
        const _FieldLabel('Instagram Link'),
        PromooTextField(
          controller: _instagramController,
          hint: 'Instagram Link',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildPricingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel('Price'),
        PromooTextField(
          controller: _priceController,
          hint: 'Price',
          keyboardType: TextInputType.number,
        ),
        const _FieldGap(),
        const _FieldLabel('Currency'),
        _DropdownField(
          hint: 'Select Currency',
          value: _currency,
          items: _currencies,
          onChanged: (value) => setState(() => _currency = value),
        ),
        const _FieldGap(),
        const _FieldLabel('Service / Product'),
        _DropdownField(
          hint: 'Select Type',
          value: _serviceType,
          items: _serviceTypes,
          onChanged: (value) => setState(() => _serviceType = value),
        ),
        const _FieldGap(),
        const _FieldLabel('Payment Method'),
        _DropdownField(
          hint: 'Select Payment Method',
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
        const SnackBar(
          content: Text('Media upload will be enabled in the next phase.'),
        ),
      );
  }

  void _createAd() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Your ad is ready! Publishing will be enabled in the next phase.',
          ),
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

class _WizardCard extends StatelessWidget {
  const _WizardCard({required this.title, required this.child});

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
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.error,
              side: BorderSide(color: context.colors.error),
            ),
            child: Text(step == 0 ? 'Cancel' : 'Back'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PromooButton.primary(
            label: step == 3 ? 'Create AD' : 'Next',
            fullWidth: true,
            onPressed: onNext,
          ),
        ),
      ],
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
  });

  final String hint;
  final IconData trailing;
  final VoidCallback onTap;

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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
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
