# Promoo design system

Last updated: 2026-06-25

## Product reasoning

- Category: marketplace/social mobile app.
- Audience: Arabic and English users discovering services, seats, profiles, subscriptions, and leaderboard content.
- Trust goal: premium, high-contrast dark UI with clear actions and predictable navigation.
- Platform target: mobile-first Flutter app with future tablet/web review.

## Style direction

- Primary style: premium dark OLED marketplace UI.
- Secondary style: dimensional dark cards with yellow brand accents.
- Avoid: low-contrast gray text, purple/blue generic gradients, black logo variants on dark surfaces, feature UI before vertical slices.

## Tokens implemented

- Colors: `lib/theme/app_colors.dart`
- Spacing: `lib/theme/app_spacing.dart`
- Radius: `lib/theme/app_radius.dart`
- Shadows: `lib/theme/app_shadows.dart`
- Typography: `lib/theme/app_typography.dart`
- Material theme: `lib/theme/app_theme.dart`

## Typography

- Varela Round remains logo-only.
- Tajawal remains the recommended UI font for Arabic and English.
- `google_fonts` was evaluated but not retained because the resolved package graph introduced platform plugin dependencies and failed on this Windows setup without Developer Mode symlink support.
- Current theme uses system fallback and does not force an unavailable font family.
- Future options: bundle Tajawal font files locally, or add `google_fonts` once local symlink support is enabled and dependency governance is updated.

## Components implemented

- `PromooScaffold`: dark safe-area scaffold with optional header/logo/actions and bottom navigation slot.
- `PromooLogo`: SVG logo wrapper using `promoo3.svg` for full contexts and `promoo.svg` for compact contexts.
- `PromooButton`: primary, secondary, tertiary, and destructive button variants.
- `PromooCard`: dark rounded bordered card with optional tap and elevation.
- `PromooTextField`: themed text input wrapper.
- `PromooLoadingIndicator`: accessible loading state.
- `PromooEmptyState`: reusable empty state with optional action.
- `PromooErrorState`: reusable error state with optional retry.
- `PromooSectionHeader`: directional section heading with optional action.

## App shell

- Shell route tabs: Home, Services, Cup, Influencer, Profile. The Influencer tab uses the `/seats` route.
- Active tab uses brand yellow.
- Inactive tabs use muted text.
- Bottom navigation uses safe-area padding, rounded dark surface, and directional spacing.
- Placeholder screens do not contain real feature logic, repositories, API calls, or mock feature data.

## Logo usage

- Splash/full contexts: `assets/brand/promoo3.svg`.
- Compact header/icon contexts: `assets/brand/promoo.svg`.
- Avoid `promoo2.svg` and `promoo4.svg` on dark backgrounds because they contain black artwork.

## RTL/LTR readiness

- Use `EdgeInsetsDirectional` and `AlignmentDirectional` for new UI.
- Keep labels short enough for English and Arabic.
- Do not concatenate user-facing translated strings in future localization work.
- Add Flutter localization/ARB setup in a later localization step, not in this shell step.

## SVG notes

- The current SVG files include embedded PNG payloads and `<style>` elements.
- `flutter_svg` renders the logo assets in tests, but logs `unhandled element <style/>`.
- Treat this as acceptable for current app rendering, but request clean vector-path SVGs or high-resolution transparent PNGs before launcher icon/native splash generation if tooling fails.
