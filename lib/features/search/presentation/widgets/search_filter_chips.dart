import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/search_result.dart';

class SearchFilterChips extends StatefulWidget {
  const SearchFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  final SearchFilterType selectedFilter;
  final ValueChanged<SearchFilterType> onSelected;

  @override
  State<SearchFilterChips> createState() => _SearchFilterChipsState();
}

class _SearchFilterChipsState extends State<SearchFilterChips> {
  final Map<SearchFilterType, GlobalKey> _chipKeys = {
    for (final filter in SearchFilterType.values) filter: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _ensureSelectedVisible();
  }

  @override
  void didUpdateWidget(covariant SearchFilterChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFilter != widget.selectedFilter) {
      _ensureSelectedVisible();
    }
  }

  void _ensureSelectedVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final context = _chipKeys[widget.selectedFilter]?.currentContext;
      if (context == null) {
        return;
      }

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: 0.5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsetsDirectional.only(
        end: AppSpacing.screenHorizontal,
      ),
      child: Row(
        children: [
          for (final filter in SearchFilterType.values) ...[
            ChoiceChip(
              key: _chipKeys[filter],
              label: Text(filter.label),
              selected: widget.selectedFilter == filter,
              onSelected: (_) => widget.onSelected(filter),
              selectedColor: AppColors.primaryYellow,
              backgroundColor: AppColors.surface,
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: widget.selectedFilter == filter
                    ? AppColors.brandBlack
                    : AppColors.textPrimary,
              ),
              side: BorderSide(
                color: widget.selectedFilter == filter
                    ? AppColors.primaryYellow
                    : AppColors.border,
              ),
            ),
            if (filter != SearchFilterType.values.last)
              const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}
