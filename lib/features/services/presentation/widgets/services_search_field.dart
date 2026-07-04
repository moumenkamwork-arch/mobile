import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';

class ServicesSearchField extends StatefulWidget {
  const ServicesSearchField({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onSubmitted,
    this.onClear,
  });

  final String query;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onClear;

  @override
  State<ServicesSearchField> createState() => _ServicesSearchFieldState();
}

class _ServicesSearchFieldState extends State<ServicesSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant ServicesSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query && widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PromooTextField(
      controller: _controller,
      hint: 'Search services',
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.primaryYellow,
      ),
      suffixIcon: widget.onClear == null
          ? null
          : IconButton(
              tooltip: 'Clear search',
              onPressed: widget.onClear,
              icon: const Icon(Icons.close_rounded),
            ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
