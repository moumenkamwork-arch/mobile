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
      title: 'Login',
      subtitle: 'Sign in to access your Promoo actions.',
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
          PromooTextField(
            controller: emailController,
            label: 'Email',
            hint: 'name@example.com',
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          PromooTextField(
            controller: passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => state.isBusy ? null : onSubmit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PromooButton.primary(
            label: state.isBusy ? 'Signing in...' : 'Login',
            icon: Icons.login_rounded,
            fullWidth: true,
            onPressed: state.isBusy ? null : onSubmit,
          ),
          const SizedBox(height: AppSpacing.sm),
          PromooButton.secondary(
            label: 'Create account',
            icon: Icons.person_add_alt_1_rounded,
            fullWidth: true,
            onPressed: state.isBusy
                ? null
                : () => context.go(AppRoutes.register),
          ),
          const SizedBox(height: AppSpacing.sm),
          PromooButton.tertiary(
            label: 'Continue as Guest',
            icon: Icons.explore_rounded,
            fullWidth: true,
            onPressed: state.isBusy ? null : () => context.go(AppRoutes.home),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AuthSocialLoginPreview(),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Forgot password is coming soon.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
