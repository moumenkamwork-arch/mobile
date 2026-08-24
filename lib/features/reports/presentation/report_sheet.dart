import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/promoo_button.dart';
import '../../../shared/widgets/promoo_sign_in_prompt.dart';
import '../../../shared/widgets/promoo_text_field.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/repositories/reports_repository_impl.dart';
import '../domain/entities/report_draft.dart';

/// Opens the report bottom sheet for [reportedType]/[reportedId] and submits
/// `POST /reports`. Shared by every "Report" entry point (profile menu,
/// content detail, story viewer). Shows its own success/failure snackbar on
/// the root [context] after closing. This is the mobile half of Apple
/// Guideline 1.2 (report objectionable content) — pairs with the block
/// feature already wired on profiles.
Future<void> showReportSheet(
  BuildContext context,
  WidgetRef ref, {
  required String reportedId,
  required ReportedType reportedType,
}) async {
  if (!ref.read(authControllerProvider).isAuthenticated) {
    showSignInRequiredSnackBar(context);
    return;
  }

  final l10n = AppLocalizations.of(context);

  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.elevatedSurface,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: _ReportSheetBody(
          reportedId: reportedId,
          reportedType: reportedType,
        ),
      );
    },
  );

  if (!context.mounted || submitted == null) {
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          submitted
              ? l10n.reportSubmittedSnackbar
              : l10n.reportFailedSnackbar,
        ),
      ),
    );
}

class _ReportSheetBody extends ConsumerStatefulWidget {
  const _ReportSheetBody({
    required this.reportedId,
    required this.reportedType,
  });

  final String reportedId;
  final ReportedType reportedType;

  @override
  ConsumerState<_ReportSheetBody> createState() => _ReportSheetBodyState();
}

class _ReportSheetBodyState extends ConsumerState<_ReportSheetBody> {
  final _detailsController = TextEditingController();
  String? _reason;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  List<(String, String)> _reasons(AppLocalizations l10n) => [
    // (wire reason, localized label). The wire value stays English/stable so
    // the admin dashboard reads a consistent set regardless of app language.
    ('Spam or misleading', l10n.reportReasonSpam),
    ('Inappropriate content', l10n.reportReasonInappropriate),
    ('Harassment or bullying', l10n.reportReasonHarassment),
    ('Scam or fraud', l10n.reportReasonScam),
    ('False information', l10n.reportReasonFalseInfo),
    ('Other', l10n.reportReasonOther),
  ];

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) {
      return;
    }
    setState(() => _isSubmitting = true);
    final result = await ref.read(reportsRepositoryProvider).submitReport(
      ReportDraft(
        reportedId: widget.reportedId,
        reportedType: widget.reportedType,
        reason: reason,
        details: _detailsController.text,
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(result.isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = _reasons(l10n);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.reportSheetTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.reportSheetSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (wire, label) in reasons)
                    ChoiceChip(
                      label: Text(label),
                      selected: _reason == wire,
                      onSelected: (_) => setState(() => _reason = wire),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              PromooTextField(
                controller: _detailsController,
                label: l10n.reportDetailsLabel,
                hint: l10n.reportDetailsHint,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: AppSpacing.lg),
              PromooButton.primary(
                label: _isSubmitting
                    ? l10n.reportSubmitting
                    : l10n.reportSubmitButton,
                fullWidth: true,
                onPressed: (_reason == null || _isSubmitting) ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
