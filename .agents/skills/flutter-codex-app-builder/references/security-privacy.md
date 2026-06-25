# Security, Privacy, and Compliance Pack

Use this for permissions, personal data, authentication, payments, analytics, ads, AI, children, UGC, legal docs, and store declarations.

## Security baseline

- No secrets, signing passwords, certificates, service-account JSON, or production tokens in repo.
- Use environment placeholders and secure CI secret stores.
- Store tokens in secure storage; avoid plain shared preferences for secrets.
- Redact PII and credentials from logs, crash reports, analytics, and error messages.
- Use TLS; consider certificate pinning only for high-risk apps with a rotation plan.
- Validate inputs on client for UX, but rely on backend validation for security.
- Review permissions and remove unused platform permissions.
- Keep dependencies updated and avoid abandoned packages for auth/payments/security.

## Privacy-by-design workflow

1. Inventory every data type collected, generated, stored, shared, or inferred.
2. Map each data item to purpose, retention, storage, third-party SDKs, and user controls.
3. Minimize collection and retention.
4. Add consent/rationale screens for sensitive permissions or tracking.
5. Update privacy policy, Google Play Data safety, and App Store privacy details.
6. Verify declarations match SDK behavior, not just first-party code.

## Data inventory template

| Data type | Source | Purpose | Required? | Stored where | Shared with | Retention | User control | Store declaration |
|---|---|---|---|---|---|---|---|---|

## Permission matrix

| Permission | Platform | Feature | User-facing rationale | Required? | Fallback if denied | Store note |
|---|---|---|---|---|---|---|

## UGC requirements

For user-generated content or social features, include:

- Filtering/moderation path.
- Report content/user.
- Block user.
- Contact/support channel.
- Terms/community guidelines.
- Abuse escalation and takedown process.

## AI feature requirements

- Disclose when user data is sent to third-party AI services.
- Avoid sending sensitive data unless necessary and consented.
- Add moderation/safety checks for generated content where risk exists.
- Provide user controls for deletion and feedback.
- Log prompts/responses only when necessary and safely redacted.

## Legal docs disclaimer

This skill can draft technical/legal templates, but final legal terms, privacy policy, and regulated-domain compliance must be reviewed by qualified counsel when risk is material.
