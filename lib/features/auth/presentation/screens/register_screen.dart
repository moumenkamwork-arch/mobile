import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/auth_session.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_account_type_selector.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_message_banner.dart';
import '../widgets/auth_screen_frame.dart';
import '../widgets/auth_signed_in_panel.dart';
import '../widgets/auth_social_login_preview.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  AuthAccountType _accountType = AuthAccountType.user;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final session = state.session;

    return AuthScreenFrame(
      child: session != null
          ? AuthSignedInPanel(
              session: session,
              isLoggingOut: state.status == AuthStatus.loggingOut,
              onLogout: () =>
                  ref.read(authControllerProvider.notifier).logout(),
            )
          : _RegisterForm(
              state: state,
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
              accountType: _accountType,
              onAccountTypeChanged: (value) {
                setState(() => _accountType = value);
              },
              onSubmit: _submit,
              onClearMessage: () =>
                  ref.read(authControllerProvider.notifier).clearMessage(),
            ),
    );
  }

  void _submit() {
    ref
        .read(authControllerProvider.notifier)
        .registerWithEmail(
          fullName: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          accountType: _accountType,
        );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.state,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.onSubmit,
    required this.onClearMessage,
  });

  final AuthState state;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthAccountType accountType;
  final ValueChanged<AuthAccountType> onAccountTypeChanged;
  final VoidCallback onSubmit;
  final VoidCallback onClearMessage;

  @override
  Widget build(BuildContext context) {
    final message = state.displayMessage;

    return PromooCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) ...[
            AuthMessageBanner(
              message: message,
              isError: state.successMessage == null,
              onDismiss: onClearMessage,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const AuthFieldLabel('Full name'),
          const SizedBox(height: AppSpacing.xs),
          PromooTextField(
            controller: nameController,
            hint: 'Full name',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          const AuthFieldLabel('Email'),
          const SizedBox(height: AppSpacing.xs),
          PromooTextField(
            controller: emailController,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          const AuthFieldLabel('Password'),
          const SizedBox(height: AppSpacing.xs),
          AuthPasswordField(
            controller: passwordController,
            onSubmitted: (_) => state.isBusy ? null : onSubmit(),
          ),
          const SizedBox(height: AppSpacing.md),
          const AuthFieldLabel('Account type'),
          const SizedBox(height: AppSpacing.xs),
          AuthAccountTypeSelector(
            selected: accountType,
            onSelected: onAccountTypeChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: state.isBusy ? 'Creating account...' : 'Create account',
            fullWidth: true,
            onPressed: state.isBusy ? null : onSubmit,
          ),
          const SizedBox(height: AppSpacing.sm),
          const AuthSocialLoginPreview(caption: 'Sign up with account'),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.secondary(
            label: 'Already have an account',
            fullWidth: true,
            onPressed: state.isBusy ? null : () => context.go(AppRoutes.login),
          ),
          const SizedBox(height: AppSpacing.xs),
          PromooButton.tertiary(
            label: 'Continue as Guest',
            fullWidth: true,
            onPressed: state.isBusy ? null : () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
