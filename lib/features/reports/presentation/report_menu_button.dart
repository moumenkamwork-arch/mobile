import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/report_draft.dart';
import 'report_sheet.dart';

/// A "⋮" overflow button whose single action opens the report sheet for
/// [reportedId]/[reportedType]. Drop into a detail header or media viewer to
/// give any piece of user content a report entry point (Apple Guideline 1.2).
class PromooReportMenuButton extends ConsumerWidget {
  const PromooReportMenuButton({
    super.key,
    required this.reportedId,
    required this.reportedType,
    this.icon = Icons.more_vert_rounded,
  });

  final String reportedId;
  final ReportedType reportedType;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<void>(
      icon: Icon(icon),
      onSelected: (_) => showReportSheet(
        context,
        ref,
        reportedId: reportedId,
        reportedType: reportedType,
      ),
      itemBuilder: (menuContext) => [
        PopupMenuItem<void>(child: Text(l10n.reportAction)),
      ],
    );
  }
}
