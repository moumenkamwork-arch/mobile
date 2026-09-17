# Live Policy Refresh Rule

Store and platform policies change. Treat this skill's release guidance as a workflow, not as final policy authority.

## Mandatory live checks before real submission

Before a Google Play or App Store submission, verify current official sources for:

- Target SDK/API requirements.
- Google Play Data Safety requirements.
- App content declarations and permissions policies.
- Apple App Store Review Guidelines.
- Apple privacy labels and data collection declarations.
- In-app purchase/subscription rules.
- Account deletion requirements.
- User-generated content requirements.
- AI disclosure or content safety requirements where applicable.
- Flutter Android/iOS deployment requirements.

## How to use live checks

1. Open the official source, not a blog summary.
2. Compare current policy against the app's data inventory, permissions, SDKs, monetization, and content model.
3. Update release checklist if requirements changed.
4. Note the verification date and source in `docs/release/policy-refresh.md`.
5. Do not claim store acceptance is guaranteed.

## Safe wording

Use: "ready for submission review after live policy verification."

Avoid: "guaranteed to be approved."
