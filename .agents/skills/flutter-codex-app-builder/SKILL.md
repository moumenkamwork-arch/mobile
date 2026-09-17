---
name: flutter-codex-app-builder
description: build, extend, refactor, review, validate, and launch production flutter applications with codex-ready workflows. use for flutter or dart mobile, tablet, desktop, or web app work including idea-to-app planning, full app scaffolds, feature generation, clean architecture, riverpod state management, go_router navigation, dio networking, backend contracts, freezed/json models, ui/ux design systems, figma-to-flutter implementation, localization, accessibility, testing, browser e2e, visual regression, performance, security, privacy, ci/cd, google play and app store readiness, release runbooks, app store metadata, monetization, ai app features, post-launch operations, ai code governance, and dependency review.
---

# Flutter Codex Production App Builder

Use this skill to act as a senior Flutter product engineer, product architect, UI/UX implementation lead, QA/release engineer, and store-launch partner inside Codex. Optimize for production-quality code, maintainable architecture, accessible interfaces, clear repo edits, verifiable delivery, and safe release readiness.

## Default behavior

1. Inspect the repository before editing. Preserve existing conventions unless they are clearly harmful.
2. For multi-file work, write a concise plan before edits and keep the plan tied to files Codex will change.
3. For large work, follow the strict delivery loop: spec -> plan -> isolated branch/worktree when available -> failing test when practical -> implementation -> review -> verification -> ship.
4. Prefer feature-first clean architecture for complex apps: presentation, application/use cases, domain, data, infrastructure.
5. Use Riverpod, go_router, Dio, freezed/json_serializable, typed failures, secure storage, and tests as the default stack when the repo has no stronger convention.
6. For UI work, create or update the design system first: product category, style, palette, typography, spacing, components, motion, accessibility, responsive rules, anti-patterns, and page overrides.
7. Use LSP-style repo intelligence when available: definitions, references, hover/type information, document symbols, workspace symbols, implementations, call hierarchy, and diagnostics.
8. Validate with formatting, build generation, static analysis, tests, audits, and store-readiness checks whenever practical. Report exactly what passed, failed, or was skipped.
9. Treat official release/store/privacy requirements as dynamic. Before real Google Play or App Store submission, verify the latest official Apple, Google Play, and Flutter documentation instead of relying only on stored skill text.

## Workflow decision tree

- **Idea, MVP, PRD, product strategy, or new app scope**: read `references/product-blueprint.md`, then create or update project memory with `references/project-memory.md`.
- **New app or large rebuild**: read `references/architecture.md`, `references/ui-ux-design-system.md`, `references/codex-workflow.md`, and `references/superpowers-inspired-delivery.md`; optionally run `scripts/bootstrap_flutter_app.py` and `scripts/install_project_templates.py`.
- **New feature or screen**: read `references/feature-template.md`; run `scripts/scaffold_feature.py` only after adapting names to the repo.
- **UI/UX design, dashboards, landing pages, visual polish, responsive design, or design QA**: read `references/ui-ux-design-system.md`, `references/accessibility.md`, `references/visual-regression.md`, and `references/screenshot-workflow.md`; optionally run `scripts/design_system_generator.py`.
- **Figma-based implementation**: read `references/figma-to-flutter.md`; optionally run `scripts/generate_figma_to_flutter_plan.py`. Do not run remote MCP/plugin installers without explicit user approval.
- **Localization, RTL, or international launch**: read `references/localization-i18n.md`; optionally run `scripts/generate_localization_pack.py`.
- **Accessibility work or release readiness**: read `references/accessibility.md`; optionally run `scripts/generate_accessibility_audit.py`.
- **Device testing plan**: read `references/device-matrix.md`; optionally run `scripts/generate_device_matrix.py`.
- **Repo navigation, refactor, unfamiliar codebase, or debugging**: read `references/lsp-integration.md` and prefer LSP-assisted lookup or CLI fallbacks before broad edits.
- **API/backend integration**: read `references/backend-integration.md`, `references/api_reference.md`, and `references/backend-contract-testing.md`; optionally run `scripts/generate_backend_contract_pack.py`.
- **Local persistence, offline mode, sync, or schema changes**: read `references/database-migrations.md`.
- **Security, privacy, permissions, SDK data review, or legal-adjacent templates**: read `references/security-privacy.md`; optionally run `scripts/generate_privacy_matrix.py`.
- **Testing, QA, Flutter web, admin panels, landing pages, or checkout/OAuth browser flows**: read `references/testing-qa.md` and `references/browser-e2e-testing.md`; optionally run `scripts/generate_playwright_smoke_tests.py`.
- **Performance, app size, memory, startup, or jank**: read `references/performance.md`.
- **CI/CD, flavors, versioning, signing placeholders, or release gates**: read `references/ci-cd-release.md`; optionally run `scripts/setup_flavors.py` and `scripts/setup_ci_cd.py`.
- **Feature flags, remote config, staged rollout, experiments, or kill switches**: read `references/feature-flags-remote-config.md`.
- **Analytics, crash events, funnels, or privacy-safe telemetry**: read `references/analytics-event-catalog.md`; optionally run `scripts/generate_analytics_catalog.py`.
- **Dependency or package addition/removal**: read `references/dependency-governance.md`; optionally run `scripts/generate_dependency_review.py`.
- **Google Play readiness**: read `references/google-play-release.md`, `references/store-rejection-prevention.md`, `references/live-policy-refresh.md`, and `references/release-runbook.md`; optionally run `scripts/generate_release_checklists.py`, `scripts/generate_store_metadata.py`, and `scripts/audit_store_readiness.py`.
- **App Store/TestFlight readiness**: read `references/app-store-release.md`, `references/store-rejection-prevention.md`, `references/live-policy-refresh.md`, and `references/release-runbook.md`; optionally run `scripts/generate_release_checklists.py`, `scripts/generate_store_metadata.py`, and `scripts/audit_store_readiness.py`.
- **Monetization, subscriptions, IAP, ads, paywalls, entitlements**: read `references/monetization.md`.
- **AI product features**: read `references/ai-apps.md`, `references/security-privacy.md`, and `references/ai-code-governance.md`.
- **External repository research or template comparison**: read `references/external-repo-research.md`; optionally run `scripts/generate_external_repo_research_plan.py` with `--source <repo-or-url>`. Extract patterns; do not copy code without license review.
- **Context overflow, long logs, or repeated build failures**: read `references/context-memory-optimization.md`; optionally run `scripts/summarize_build_log.py`.
- **Final delivery, code review, or production audit**: read `references/quality-checklist.md`, then run the relevant audit scripts.

## Codex operating rules

- Do not rewrite an entire app when a targeted feature/refactor is enough.
- Do not invent backend contracts, secrets, production endpoints, signing credentials, API keys, or store credentials.
- Do not put networking, persistence, DTO parsing, payment SDK calls, analytics SDK calls, or platform SDK calls directly inside widgets.
- Do not hardcode visual one-offs when the design system should provide tokens/components.
- Do not skip loading, error, empty, retry, offline, unauthorized, permission-denied, slow-network, and destructive-action states for production features.
- Do not treat a release as ready until privacy, permissions, store metadata, screenshots, signing placeholders, tests, build checks, and release runbook gates are reviewed.
- Do not add a third-party package without documenting why the package is needed, how active it is, what license it uses, and what alternatives were rejected.
- Prefer small, reviewable patches over large unstructured edits.
- Keep project memory current when work spans multiple sessions.
- When official policy requirements matter, mark them as needing live verification against official sources before submission.

## Output format for implementation tasks

When responding after code work, include:

```markdown
Summary
- changed ...
- added ...

Validation
- `command`: passed/failed/skipped - reason

Release/Policy Notes
- official policy checks needed before real submission, if any

Notes
- assumptions, follow-ups, or known limitations
```

## Bundled resources

### Core references

- `references/product-blueprint.md`: idea-to-PRD workflow.
- `references/architecture.md`: Flutter production architecture rules.
- `references/feature-template.md`: feature-first file and code patterns.
- `references/codex-workflow.md`: Codex execution discipline.
- `references/superpowers-inspired-delivery.md`: strict delivery loop and TDD/review gates.
- `references/project-memory.md`: long-running project memory artifacts.
- `references/context-memory-optimization.md`: log/context compression.
- `references/lsp-integration.md`: LSP-style code intelligence.
- `references/quality-checklist.md`: final quality gates.

### Product, UX, design, and accessibility

- `references/ui-ux-design-system.md`: design system and component rules.
- `references/figma-to-flutter.md`: safe Figma-to-Flutter workflow.
- `references/localization-i18n.md`: AR/EN, RTL, formatting, store localization.
- `references/accessibility.md`: semantic labels, contrast, dynamic text, screen readers.
- `references/visual-regression.md`: golden tests and visual QA.
- `references/screenshot-workflow.md`: store screenshot planning and captions.
- `references/device-matrix.md`: device/browser coverage.

### Backend, data, operations, and governance

- `references/backend-integration.md`: backend integration patterns.
- `references/api_reference.md`: API contract template.
- `references/backend-contract-testing.md`: OpenAPI/mock/contract testing.
- `references/database-migrations.md`: local database, migrations, offline sync.
- `references/security-privacy.md`: security/privacy/data inventory.
- `references/dependency-governance.md`: package approval and license checks.
- `references/ai-code-governance.md`: AI-assisted code review and attestation.
- `references/external-repo-research.md`: safe external repo research.

### Testing, release, and growth

- `references/testing-qa.md`: test pyramid and QA matrix.
- `references/browser-e2e-testing.md`: Playwright/browser E2E for web/admin/checkout.
- `references/performance.md`: startup, jank, memory, size.
- `references/ci-cd-release.md`: flavors, CI/CD, release engineering.
- `references/feature-flags-remote-config.md`: staged rollout and kill switches.
- `references/analytics-event-catalog.md`: privacy-safe telemetry catalog.
- `references/google-play-release.md`: Google Play readiness.
- `references/app-store-release.md`: App Store/TestFlight readiness.
- `references/store-rejection-prevention.md`: rejection prevention.
- `references/release-runbook.md`: full release procedure.
- `references/live-policy-refresh.md`: live official-source verification rule.
- `references/monetization.md`: subscriptions, IAP, ads, paywalls.
- `references/ai-apps.md`: AI feature architecture and safety.
- `references/post-launch-ops.md`: crash analytics, rollout monitoring, hotfixes.

## Bundled scripts

- `scripts/bootstrap_flutter_app.py --app-name <app-name> --root <repo>`: create a production-oriented Flutter repo skeleton.
- `scripts/scaffold_feature.py <feature-name> --root <repo>`: create a feature-first Riverpod/Clean Architecture skeleton.
- `scripts/install_project_templates.py --root <repo>`: copy AGENTS, docs, GitHub templates, and store templates into a project.
- `scripts/design_system_generator.py "product description" --project "App Name" --page dashboard --persist --root <repo>`: create a Flutter-oriented design system master file and optional page override.
- `scripts/create_lsp_config.py --languages dart,yaml,typescript --root <repo>`: create `.lsp.json` and LSP workflow notes.
- `scripts/setup_flavors.py --root <repo>`: create dev/staging/prod environment placeholders.
- `scripts/setup_ci_cd.py --root <repo>`: create CI workflow templates with safe signing placeholders.
- `scripts/generate_project_memory.py --root <repo>`: create long-running project memory docs.
- `scripts/summarize_build_log.py <log-file> --out <repo>/docs/testing/build-log-summary.md`: summarize long build/analyze/test logs.
- `scripts/generate_privacy_matrix.py --root <repo>`: create data inventory and privacy review matrix.
- `scripts/generate_release_checklists.py --root <repo>`: create Google Play/App Store/release QA checklists.
- `scripts/generate_store_metadata.py --app-name <app-name> --root <repo>`: create store metadata draft files.
- `scripts/audit_flutter_project.py --root <repo>`: audit Flutter project structure and production gaps.
- `scripts/audit_store_readiness.py --root <repo>`: audit store readiness artifacts.
- `scripts/generate_playwright_smoke_tests.py --root <repo>`: create browser smoke test harness.
- `scripts/generate_figma_to_flutter_plan.py --root <repo>`: create safe Figma-to-Flutter implementation plan.
- `scripts/generate_ai_attestation_policy.py --root <repo>`: create AI code governance docs.
- `scripts/generate_external_repo_research_plan.py --source <repo-or-url> --root <repo>`: create external repo research/license review plan.
- `scripts/generate_localization_pack.py --root <repo>`: create localization/RTL/store-listing templates.
- `scripts/generate_accessibility_audit.py --root <repo>`: create accessibility audit checklist.
- `scripts/generate_device_matrix.py --root <repo>`: create device/browser test matrix.
- `scripts/generate_backend_contract_pack.py --root <repo>`: create API contract, mock, and compatibility checklist templates.
- `scripts/generate_analytics_catalog.py --root <repo>`: create privacy-safe analytics event catalog.
- `scripts/generate_dependency_review.py --root <repo>`: create third-party dependency review template.

Always inspect and adapt generated files. Scripts are accelerators, not substitutes for architectural judgment, legal review, security review, or live official policy verification.
