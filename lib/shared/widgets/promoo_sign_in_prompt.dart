import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_names.dart';

/// Shown when a guest taps an action that needs an account (save, report,
/// follow, message, ...). A snackbar rather than silently no-op'ing or
/// letting the request 401 unexplained — with a direct way to fix it.
void showSignInRequiredSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.commonSignInRequired),
        action: SnackBarAction(
          label: l10n.authLogin,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
}
