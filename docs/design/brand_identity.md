# Promoo brand identity

## Brand source

- Official logo font: Varela Round.
- Official primary yellow: `#FFE604`.
- Official primary black: `#000000`.
- App UI language support: Arabic and English.
- App text direction support: RTL and LTR.
- Visual direction: premium dark UI, black backgrounds, strong yellow accents, modern dark cards, rounded corners, high contrast, and a polished marketplace/social app feel.

## Detected logo files

| File | Detected content | Best use |
| --- | --- | --- |
| `assets/brand/promoo.svg` | Standalone yellow `P` mark with two dark-yellow dot details. SVG canvas is `1280x1314`; art is embedded PNG plus vector circles. | App icon source, small icon usage, compact header icon, splash fallback. |
| `assets/brand/promoo2.svg` | Standalone black `P` mark with two dark-yellow dot details. SVG canvas is `1280x1314`; art is embedded PNG plus vector circles. | Only for yellow or light surfaces. Avoid on black/dark app backgrounds. |
| `assets/brand/promoo3.svg` | Full yellow Promoo wordmark: standalone `P` mark plus `romoo`. SVG canvas is `1280x1314`; art is embedded PNG plus vector circles. | Primary splash logo, login logo, wide app header wordmark. |
| `assets/brand/promoo4.svg` | Full black Promoo wordmark: standalone `P` mark plus `romoo`. SVG canvas is `1280x1314`; art is embedded PNG plus vector circles. | Only for yellow or light surfaces. Avoid on black/dark app backgrounds. |

## Recommended logo usage

- Splash screen: use `assets/brand/promoo3.svg` centered on brand black for the full brand read. Use `assets/brand/promoo.svg` only if a compact mark is required.
- Login screen: use `assets/brand/promoo3.svg` above the auth form for stronger brand recognition.
- App header: use `assets/brand/promoo3.svg` when width allows; use `assets/brand/promoo.svg` for compact headers, tabs, or tight toolbars.
- App icon source: use `assets/brand/promoo.svg` as the source artwork later. Do not generate launcher icons in this step.
- Small icon usage: use `assets/brand/promoo.svg`; avoid the full wordmark below comfortable readable sizes.
- Black logo variants: reserve `promoo2.svg` and `promoo4.svg` for yellow, white, or light marketing surfaces, not the main dark app UI.

## Initial color tokens

| Token | Value | Usage |
| --- | --- | --- |
| `brandBlack` | `#000000` | Official black, app background anchor. |
| `brandYellow` | `#FFE604` | Official primary yellow, primary action and brand accent. |
| `background` | `#000000` | Main app background. |
| `surface` | `#101010` | Default dark surfaces. |
| `cardSurface` | `#181818` | Cards and list tiles. |
| `elevatedSurface` | `#202020` | Raised cards, sheets, selected nav. |
| `primaryYellow` | `#FFE604` | Primary buttons, active icons, highlights. |
| `softYellow` | `#FFF36A` | Hover, subtle badges, secondary accents. |
| `darkYellow` | `#C7B000` | Pressed states and low-emphasis yellow borders. |
| `textPrimary` | `#FFFFFF` | Primary text on dark UI. |
| `textSecondary` | `#B8B8B8` | Secondary labels and descriptions. |
| `textMuted` | `#7A7A7A` | Disabled and metadata text. |
| `border` | `#2A2A2A` | Dividers, inputs, card borders. |
| `error` | `#FF4D4F` | Destructive and validation states. |
| `success` | `#3DDC84` | Success and confirmed states. |

## Typography direction

- Keep Varela Round for the logo only.
- Do not force Varela Round for Arabic UI text.
- Recommended app UI font for the design-system step: Tajawal, because it supports Arabic UI text well and can pair cleanly with English.
- Until custom fonts are configured, use Flutter/system fallback fonts.
- Future theme should define locale-aware text styles rather than one global font override.
- Prefer clear mobile hierarchy: display, title, body, label, and caption styles with predictable weights.

## Spacing scale

- `0`: `0`
- `1`: `4`
- `2`: `8`
- `3`: `12`
- `4`: `16`
- `5`: `20`
- `6`: `24`
- `8`: `32`
- `10`: `40`
- `12`: `48`
- Use `16` as the default screen horizontal padding on phones.
- Use `8` or `12` for dense marketplace rows, chips, and metadata.
- Use `24` or `32` for section separation.

## Radius scale

- `xs`: `6`
- `sm`: `8`
- `md`: `12`
- `lg`: `16`
- `xl`: `24`
- Buttons should generally use `12` to `16`.
- Cards should generally use `16`.
- Bottom sheets and modal surfaces can use `24` on the top corners.

## Button styles

- Primary button: `primaryYellow` background, black label/icon, radius `16`, height `48` to `52`, medium or bold label.
- Secondary button: transparent or `surface` background, `border` outline, `textPrimary` label, yellow icon or accent when helpful.
- Tertiary button: text/icon button using `primaryYellow` for positive actions and `textSecondary` for neutral actions.
- Destructive button: `error` accent with clear confirmation for destructive flows.
- All touch targets should be at least `44x44`.

## Card styles

- Default card background: `cardSurface`.
- Elevated card background: `elevatedSurface`.
- Border: `1` logical pixel using `border`.
- Radius: `16`.
- Padding: `16` for standard cards, `12` for dense cards.
- Avoid one-off yellow panels; use yellow for accents, badges, active states, and primary actions.

## Input styles

- Filled dark inputs using `surface` or `cardSurface`.
- Border color: `border`; focused border: `primaryYellow`.
- Radius: `12` to `16`.
- Label/helper text: `textSecondary`.
- Placeholder text: `textMuted`.
- Error text and border: `error`.
- Use directional padding and alignment so Arabic and English fields mirror correctly.

## Bottom navigation style

- Background: `surface` or `#050505` over black.
- Active item: `primaryYellow` icon/label, optional subtle elevated pill using `elevatedSurface`.
- Inactive item: `textMuted` icon/label.
- Top border: `border`.
- Keep labels short in both English and Arabic.
- Use safe-area padding and maintain at least `44x44` item targets.

## RTL and LTR notes

- Use `Directionality`, `EdgeInsetsDirectional`, `AlignmentDirectional`, and directional border radius where applicable.
- Mirror horizontal navigation, leading/trailing actions, back affordances, and carousel/list movement in Arabic.
- Do not concatenate translated strings.
- Plan for Flutter `gen_l10n` with ARB files in a later localization setup step.
- Brand name and logo should remain stable across Arabic and English unless the client provides a localized brand mark.
- Test English and Arabic with small and large text scale before release.

## SVG compatibility notes

- All four SVGs are Illustrator exports.
- The logo shapes are not pure vector paths. They use embedded base64 PNG images inside SVG `<image>` tags, plus vector circles.
- All SVGs use `xmlns:xlink` and `xlink:href` for the embedded image payloads.
- This should be treated as acceptable for app asset use with `flutter_svg`, but it is less portable than clean vector-path SVGs.
- Compatibility check on 2026-06-25: `dart run vector_graphics_compiler --input-dir assets\brand --out-dir <temp>` compiled all four SVG files successfully.
- Widget test rendering on 2026-06-25 succeeded, but `flutter_svg` logs `unhandled element <style/>` for the current Illustrator exports.
- Some icon-generation tools, native splash tools, or strict SVG optimizers may reject embedded PNG data URIs.
- If a future launcher icon or native splash generator fails, request clean vector-path SVG exports or high-resolution transparent PNG exports from the designer.
- `promoo2.svg` and `promoo4.svg` contain black artwork, so they will be invisible on the main black app background.

## Dependency note

- package: `flutter_svg`
- purpose: render the provided SVG brand assets in Flutter.
- license: MIT, verified from the resolved package license file.
- data collected: none.
- permissions/platform impact: no platform permissions expected.
- alternatives considered: raster PNG assets only, but that would lose SVG layout flexibility and duplicate generated sizes.
- owner: Promoo Flutter app.
- review date: 2026-06-25.

## Design-system implementation

- Flutter design tokens and shared components are implemented in `lib/theme/` and `lib/shared/widgets/`.
- The placeholder app shell is implemented in `lib/shell/`.
- `google_fonts` was evaluated but not retained because it failed dependency resolution on this Windows setup without Developer Mode symlink support.
- Keep using system fallback until Tajawal is added through bundled font assets or a supported `google_fonts` setup.
- Do not build feature screens outside the roadmap vertical-slice workflow.
