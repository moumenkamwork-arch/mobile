import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_spacing.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final String query;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant SearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PromooTextField(
            controller: _controller,
            hint: 'Search profiles, services, offers',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: widget.query.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: widget.onClear,
                  ),
            textInputAction: TextInputAction.search,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PromooButton.primary(
          label: 'Search',
          icon: Icons.search_rounded,
          onPressed: () => widget.onSubmitted(_controller.text),
        ),
      ],
    );
  }
}
