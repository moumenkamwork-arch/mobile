# Safe Figma-to-Flutter Workflow

Use this when the user provides Figma designs, design tokens, screenshots, or asks to convert a design into Flutter UI.

## Safety and dependency rules

- Do not install or run remote MCP/plugin scripts without user approval.
- Treat Figma MCP or export tooling as optional. The skill must still work from screenshots, exported JSON, or manual specs.
- Do not copy proprietary assets into the repo unless the user confirms rights.
- Store generated tokens and component notes in repo docs before coding.

## Figma extraction checklist

Extract or ask for:

- Frame/page name and target platform.
- Layout constraints and breakpoints.
- Color styles and semantic token mapping.
- Typography styles and fallback fonts.
- Spacing scale, radii, elevation, strokes.
- Components, variants, and states.
- Icons/images and licensing status.
- Dark mode behavior.
- Accessibility notes and contrast risks.

## Conversion workflow

1. Create `docs/design/FIGMA_MAPPING.md`.
2. Map raw styles to semantic Flutter design tokens.
3. Define reusable components before page-specific UI.
4. Implement tokens in `lib/design_system/tokens` and theme extensions.
5. Implement components in `lib/design_system/components`.
6. Build screens using tokens/components only.
7. Add widget/golden tests when the project supports them.
8. Compare against Figma/screenshot and document intentional deviations.

## Flutter mapping rules

- Use semantic names like `color.surface.primary`, not raw color names like `blue500` in feature UI.
- Avoid pixel-perfect hardcoding when responsive/adaptive behavior is required.
- Prefer composition over giant screen widgets.
- Include loading, empty, error, disabled, pressed, focused, and offline states.
- Validate touch target sizes and text scaling.
