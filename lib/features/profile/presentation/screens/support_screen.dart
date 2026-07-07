import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// "Support" page: 24/7 contact entry points and a message form.
/// Phase A: local-only; sending connects to support tooling later.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PromooSubpageScaffold(
      title: 'Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromooCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      color: AppColors.primaryYellow,
                      size: 30,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'We are here 24/7',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Questions about offers, seats, or your account? '
                  'Reach the Promoo team any time.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PromooCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ContactRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'support@promoo.app',
                  onTap: () => _showNotice(context),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Divider(height: 1),
                ),
                _ContactRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat with support',
                  onTap: () => _showNotice(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PromooCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Send us a message',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                PromooTextField(
                  controller: _messageController,
                  hint: 'Describe your issue or question',
                ),
                const SizedBox(height: AppSpacing.md),
                PromooButton.primary(
                  label: 'Send',
                  fullWidth: true,
                  onPressed: () => _showNotice(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotice(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Support messaging will be connected in the next phase.',
          ),
        ),
      );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      leading: Icon(icon, color: AppColors.primaryYellow),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
