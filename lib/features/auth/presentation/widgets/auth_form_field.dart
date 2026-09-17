import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';

/// Field label shown above an [AuthFormField]/[AuthPasswordField], matching
/// the labeled-field style from the original Login/Register MVP screens.
class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Password field with a show/hide toggle, matching the Login/Register MVP.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    this.hint,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  final TextEditingController controller;

  /// Defaults to the localized "Password" when not overridden.
  final String? hint;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooTextField(
      controller: widget.controller,
      hint: widget.hint ?? l10n.authFieldPassword,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      suffixIcon: IconButton(
        tooltip: _obscure ? l10n.authPasswordShow : l10n.authPasswordHide,
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
