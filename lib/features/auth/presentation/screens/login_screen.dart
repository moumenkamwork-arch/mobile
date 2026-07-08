import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_message_banner.dart';
import '../widgets/auth_screen_frame.dart';
import '../widgets/auth_signed_in_panel.dart';
import '../widgets/auth_social_login_preview.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

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
    final session = state.session;

    return AuthScreenFrame(
      showBackButton: false,
      child: session != null
          ? AuthSignedInPanel(
              session: session,
              isLoggingOut: state.status == AuthStatus.loggingOut,
              onLogout: () =>
                  ref.read(authControllerProvider.notifier).logout(),
            )
          : _LoginForm(
              state: state,
              emailController: _emailController,
              passwordController: _passwordController,
              onSubmit: _submit,
              onClearMessage: () =>
                  ref.read(authControllerProvider.notifier).clearMessage(),
            ),
    );
  }

  void _submit() {
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
    required this.onSubmit,
    required this.onClearMessage,
  });

  final AuthState state;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onClearMessage;

  @override
  Widget build(BuildContext context) {
    final message = state.displayMessage;
    final colors = context.colors;

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
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: state.isBusy ? 'Signing in...' : 'Login',
            fullWidth: true,
            onPressed: state.isBusy ? null : onSubmit,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.center,
            child: TextButton(
              onPressed: state.isBusy
                  ? null
                  : () => _showComingSoon(context, 'Password reset'),
              child: Text(
                'forget password?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AuthSocialLoginPreview(),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: 'Sign Up',
            fullWidth: true,
            // Push keeps Login beneath, so back returns here step-wise.
            onPressed: state.isBusy
                ? null
                : () => context.push(AppRoutes.register),
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

void _showComingSoon(BuildContext context, String label) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text('$label coming soon')));
}
