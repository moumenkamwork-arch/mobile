import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/legal/legal_urls.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// "Support" page: the one official contact address, and a message box that
/// opens the device's mail app pre-addressed to it (there is no in-app
/// support-ticket backend, so this — not a fake "chat with support" — is the
/// real channel).
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
            child: _ContactRow(
              icon: Icons.mail_outline_rounded,
              label: LegalUrls.supportEmail,
              onTap: () => _openMailApp(context),
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
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMailApp(BuildContext context) => _launchMailto(
    context,
    subject: 'Promoo support',
  );

  /// No support-ticket backend exists, so "sending" hands the message off to
  /// the device's own mail app, pre-addressed and pre-filled — the user still
  /// presses Send there themselves, same as tapping the email row directly.
  Future<void> _sendMessage(BuildContext context) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    final sent = await _launchMailto(
      context,
      subject: 'Promoo support',
      body: message,
    );
    if (sent && mounted) {
      _messageController.clear();
    }
  }

  Future<bool> _launchMailto(
    BuildContext context, {
    required String subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: LegalUrls.supportEmail,
      query: Uri(
        queryParameters: {'subject': subject, 'body': body ?? ''},
      ).query,
    );

    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      _showNotice(context, AppLocalizations.of(context).profileSupportMailAppMissing);
    }
    return launched;
  }

  void _showNotice(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
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
