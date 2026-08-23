import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_legal_consent.dart';
import '../widgets/auth_message_banner.dart';
import '../widgets/auth_messages.dart';
import '../widgets/auth_screen_frame.dart';
import '../widgets/auth_signed_in_panel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _agreedToLegal = false;
  String? _consentError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    // Auto-navigate to home as soon as authentication succeeds
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status != AuthStatus.authenticated) {
        if (GoRouter.maybeOf(context) != null) {
          context.go(AppRoutes.home);
        }
      }
    });

    final showSignedInPanel =
        state.session != null && state.status == AuthStatus.authenticated;

    return AuthScreenFrame(
      showBackButton: false,
      child: showSignedInPanel
          ? AuthSignedInPanel(
              session: state.session!,
              isLoggingOut: false,
              onLogout: () =>
                  ref.read(authControllerProvider.notifier).logout(),
            )
          : _LoginForm(
              state: state,
              emailController: _emailController,
              passwordController: _passwordController,
              agreedToLegal: _agreedToLegal,
              consentError: _consentError,
              onAgreedChanged: (value) {
                setState(() {
                  _agreedToLegal = value;
                  if (value) {
                    _consentError = null;
                  }
                });
              },
              onSubmit: _submit,
              onClearMessage: () =>
                  ref.read(authControllerProvider.notifier).clearMessage(),
            ),
    );
  }

  void _submit() {
    if (!_agreedToLegal) {
      setState(() {
        _consentError = AppLocalizations.of(context).authAgreeRequired;
      });
      return;
    }

    setState(() => _consentError = null);
    ref
        .read(authControllerProvider.notifier)
        .loginWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.state,
    required this.emailController,
    required this.passwordController,
    required this.agreedToLegal,
    required this.consentError,
    required this.onAgreedChanged,
    required this.onSubmit,
    required this.onClearMessage,
  });

  final AuthState state;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool agreedToLegal;
  final String? consentError;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback onSubmit;
  final VoidCallback onClearMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = resolveAuthMessage(l10n, state);

    return PromooCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) ...[
            AuthMessageBanner(
              message: message.text,
              isError: message.isError,
              onDismiss: onClearMessage,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AuthFieldLabel(l10n.authFieldEmail),
          const SizedBox(height: AppSpacing.xs),
          PromooTextField(
            controller: emailController,
            hint: l10n.authFieldEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          AuthFieldLabel(l10n.authFieldPassword),
          const SizedBox(height: AppSpacing.xs),
          AuthPasswordField(
            controller: passwordController,
            onSubmitted: (_) => state.isBusy ? null : onSubmit(),
          ),
          const SizedBox(height: AppSpacing.md),
          AuthLegalConsent(
            value: agreedToLegal,
            enabled: !state.isBusy,
            onChanged: onAgreedChanged,
          ),
          if (consentError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              consentError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: state.isBusy ? l10n.authLoggingIn : l10n.authLogin,
            fullWidth: true,
            onPressed: state.isBusy ? null : onSubmit,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              const SizedBox(width: AppSpacing.lg),
              const Text('Or'),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: l10n.authSignUp,
            fullWidth: true,
            onPressed: state.isBusy
                ? null
                : () => context.push(AppRoutes.register),
          ),
          const SizedBox(height: AppSpacing.xs),
          PromooButton.tertiary(
            label: l10n.authContinueAsGuest,
            fullWidth: true,
            onPressed: state.isBusy ? null : () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
