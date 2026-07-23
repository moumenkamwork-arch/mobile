import 'package:flutter/material.dart';

import '../../../../theme/app_spacing.dart';
import '../../domain/entities/search_result.dart';
import 'search_result_card.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.results,
    required this.onProfileSelected,
    this.onServiceSelected,
    this.onOfferSelected,
  });

  final List<SearchResult> results;
  final ValueChanged<SearchProfileResult> onProfileSelected;
  final ValueChanged<SearchServiceResult>? onServiceSelected;
  final ValueChanged<SearchOfferResult>? onOfferSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < results.length; i++) ...[
          SearchResultCard(result: results[i], onTap: _onTapFor(results[i])),
          if (i != results.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  VoidCallback? _onTapFor(SearchResult result) {
    if (result is SearchProfileResult) {
      return () => onProfileSelected(result);
    }
    if (result is SearchServiceResult && onServiceSelected != null) {
      return () => onServiceSelected!(result);
    }
    if (result is SearchOfferResult && onOfferSelected != null) {
      return () => onOfferSelected!(result);
    }
    return null;
  }
}
