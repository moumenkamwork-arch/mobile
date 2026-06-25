# Store Rejection Prevention Pack

Use this before any store submission, especially for apps with auth, UGC, payments, AI, health, finance, children, location, or sensitive data.

## Common rejection risks

| Risk | Prevention |
|---|---|
| Crashes or broken core flows | Run smoke tests on real devices and store test tracks. |
| Placeholder metadata/content | Scrub lorem ipsum, test URLs, debug banners, fake products. |
| Missing demo account | Provide active account or full demo mode in review notes. |
| Backend unavailable | Confirm production/staging review backend is live. |
| Privacy mismatch | Align code, SDKs, permissions, privacy policy, Play Data safety, and App Store privacy details. |
| Unjustified permissions | Remove or explain; add graceful denied state. |
| UGC without moderation | Add report, block, filtering, support contact, and terms. |
| Payments outside store rules | Use correct IAP/subscription rules where required. |
| Low-value app | Add native utility, polished UX, real content, and clear differentiation. |
| Misleading screenshots/description | Ensure assets match real app behavior. |
| AI data sharing undisclosed | Add consent/disclosure and privacy documentation. |
| Account deletion missing | Add deletion path when accounts are created, or document support path when allowed. |

## Final submission gate

Do not submit until this statement is true:

> A reviewer can install the app, understand its purpose, access all reviewable features, complete the core journey without crashes, verify purchases/UGC/AI/permissions where relevant, and see metadata/privacy declarations that match the app.
