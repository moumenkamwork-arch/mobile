import 'package:flutter/material.dart';
import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/legal/legal_urls.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// Checkbox + linked Terms of Use / Privacy Policy for auth screens.
class AuthLegalConsent extends StatelessWidget {
  const AuthLegalConsent({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final linkStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: colors.primaryYellow,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: colors.primaryYellow,
    );
    final bodyStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: colors.textSecondary,
      height: 1.35,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: enabled
                ? (checked) => onChanged(checked ?? false)
                : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 2),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(l10n.authAgreePrefix, style: bodyStyle),
                GestureDetector(
                  onTap: enabled ? () => _open(LegalUrls.termsOfUse) : null,
                  child: Text(l10n.authTermsOfUse, style: linkStyle),
                ),
                Text(l10n.authAgreeAnd, style: bodyStyle),
                GestureDetector(
                  onTap: enabled
                      ? () => _open(LegalUrls.privacyPolicy)
                      : null,
                  child: Text(l10n.authPrivacyPolicy, style: linkStyle),
                ),
                Text(l10n.authAgreeSuffix, style: bodyStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
