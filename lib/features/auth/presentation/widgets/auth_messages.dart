import '../../../../l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

/// Resolves an [AuthState] into a message to show the user (validation issue,
/// backend/data-layer failure, or the post-registration notice) plus whether
/// it should render as an error or a success banner. Lives here (not on
/// [AuthState] itself) because resolving it needs `AppLocalizations`, and the
/// controller has no `BuildContext`.
class AuthDisplayMessage {
  const AuthDisplayMessage({required this.text, required this.isError});

  final String text;
  final bool isError;
}

AuthDisplayMessage? resolveAuthMessage(AppLocalizations l10n, AuthState state) {
  final issue = state.validationIssue;
  if (issue != null) {
    return AuthDisplayMessage(text: _issueText(l10n, issue), isError: true);
  }

  final failure = state.failure;
  if (failure != null) {
    // Data-layer failure messages (from AppFailure) are a cross-cutting
    // concern shared by every feature's Result<T, AppFailure> — out of scope
    // for this screen-by-screen localization pass; see docs/localization_plan.md.
    return AuthDisplayMessage(text: failure.message, isError: true);
  }

  if (state.registrationPending) {
    return AuthDisplayMessage(
      text: l10n.authRegistrationPendingVerification,
      isError: false,
    );
  }

  return null;
}

String _issueText(AppLocalizations l10n, AuthValidationIssue issue) {
  return switch (issue) {
    AuthValidationIssue.emailRequired => l10n.authValidationEmailRequired,
    AuthValidationIssue.emailInvalid => l10n.authValidationEmailInvalid,
    AuthValidationIssue.passwordRequired => l10n.authValidationPasswordRequired,
    AuthValidationIssue.fullNameTooShort => l10n.authValidationFullNameTooShort,
    AuthValidationIssue.passwordTooShort => l10n.authValidationPasswordTooShort,
  };
}
