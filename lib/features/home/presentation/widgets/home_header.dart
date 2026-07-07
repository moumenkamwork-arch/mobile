import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_page_header.dart';

/// Home header — the shared full-width Promoo bar (logo + chat/notification
/// icons). Kept as a thin alias so the Home pinned sliver keeps its name.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.isScrolled = false});

  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    return PromooPageHeader(isScrolled: isScrolled, applyTopSafeArea: true);
  }
}
