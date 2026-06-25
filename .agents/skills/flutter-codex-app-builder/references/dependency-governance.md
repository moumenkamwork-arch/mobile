# Dependency Governance

Use this guide before adding, upgrading, replacing, or removing third-party packages.

## Approval checklist

- What problem does the package solve?
- Could the existing stack solve it?
- Is the package actively maintained?
- Is the license acceptable for the project?
- Does it collect data or include SDK behavior relevant to store privacy declarations?
- Does it affect app size, startup, build complexity, or platform permissions?
- Is there a smaller or official alternative?
- What is the removal plan if the package becomes unmaintained?

## Sensitive dependency categories

Require extra review for:

- Payments, subscriptions, ads, attribution, analytics.
- Authentication and identity.
- Encryption/security.
- AI SDKs and prompt/data transfer.
- Push notifications.
- Background location, contacts, photos, microphone, camera.
- Native platform plugins.

## Documentation requirement

When adding a package, update dependency review docs with:

```text
package:
purpose:
license:
data collected:
permissions/platform impact:
alternatives considered:
owner:
review date:
```
