import 'package:promoo_app/l10n/app_localizations.dart';
import '../../../../core/errors/app_failure.dart';
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

  if (state.sessionExpired) {
    return AuthDisplayMessage(
      text: l10n.authSessionExpiredNotice,
      isError: true,
    );
  }

  final failure = state.failure;
  if (failure != null) {
    return AuthDisplayMessage(text: _failureText(l10n, failure), isError: true);
  }

  if (state.registrationPending) {
    return AuthDisplayMessage(
      text: l10n.authRegistrationPendingVerification,
      isError: false,
    );
  }

  return null;
}

/// Maps a data-layer [AppFailure] to a friendly, localized, event-appropriate
/// message. The most important case is a login/register 401 → "wrong email or
/// password" instead of the raw backend string ("Invalid login credentials").
String _failureText(AppLocalizations l10n, AppFailure failure) {
  return switch (failure.type) {
    AppFailureType.unauthorized => l10n.authErrorInvalidCredentials,
    AppFailureType.network || AppFailureType.timeout => l10n.authErrorNoConnection,
    AppFailureType.validation =>
      failure.message.isNotEmpty ? failure.message : l10n.authErrorGeneric,
    _ => l10n.authErrorGeneric,
  };
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
