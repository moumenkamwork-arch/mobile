import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';

/// The canonical (English) category values used internally by the Add
/// Offer / Add Service forms. Kept English so the eventual `category_id`
/// wiring doesn't need to change; display text is resolved separately via
/// [addCategoryLabel].
const List<String> addCategoryValues = [
  'Beauty & Wellness',
  'Restaurants & Cafes',
  'Events & Photography',
  'Digital Marketing',
];

/// Resolves the localized display label for a canonical add-form category.
String addCategoryLabel(BuildContext context, String category) {
  final l10n = AppLocalizations.of(context);
  return switch (category) {
    'Beauty & Wellness' => l10n.addCommonCategoryBeautyWellness,
    'Restaurants & Cafes' => l10n.addCommonCategoryRestaurantsCafes,
    'Events & Photography' => l10n.addCommonCategoryEventsPhotography,
    'Digital Marketing' => l10n.addCommonCategoryDigitalMarketing,
    _ => category,
  };
}
