import 'package:promoo_app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return PromooSubpageScaffold(
      title: l10n.menuSupport,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromooCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      color: context.colors.accent,
                      size: 30,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.profileSupportHeroTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.profileSupportHeroBody,
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
                  label: l10n.profileSupportChatLabel,
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
                  l10n.profileSupportMessageTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                PromooTextField(
                  controller: _messageController,
                  hint: l10n.profileSupportMessageHint,
                ),
                const SizedBox(height: AppSpacing.md),
                PromooButton.primary(
                  label: l10n.profileSupportSendButton,
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
        SnackBar(
          content: Text(AppLocalizations.of(context).profileSupportComingSoon),
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
      leading: Icon(icon, color: context.colors.accent),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.colors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
