# Accessibility

Use this guide for every production UI, not only after launch. Accessibility is a release gate.

## Core rules

1. Provide semantic labels for icon-only buttons, custom controls, charts, and media controls.
2. Ensure meaningful focus order for web, desktop, TV, and keyboard users.
3. Support dynamic text scaling without clipping important content.
4. Use sufficient contrast for text, icons, disabled states, and interactive boundaries.
5. Keep tap targets large enough for comfortable touch use.
6. Do not use color alone to communicate state.
7. Provide visible loading, error, empty, and retry states.
8. Avoid motion that is essential for understanding the UI.
9. Make destructive actions reversible or confirmed.
10. Test with platform screen readers where practical.

## Flutter implementation checklist

- Use `Semantics` for custom widgets.
- Use `Tooltip` or explicit text labels for icon-only actions.
- Use `MergeSemantics` or `ExcludeSemantics` only intentionally.
- Prefer `TextButton`, `ElevatedButton`, `IconButton`, and Material controls before custom gesture handlers.
- Avoid raw `GestureDetector` for tappable UI unless semantic behavior is added.
- Use `MediaQuery.textScalerOf(context)` behavior intentionally.
- Use `SafeArea` where needed.
- Use `FocusTraversalGroup` for complex web/desktop flows.

## QA matrix

- Screen reader announces screen title and primary actions.
- Keyboard navigation reaches all interactive controls.
- Forms announce labels, errors, and required fields.
- Dialogs trap focus and return focus after dismissal.
- Dark mode maintains contrast.
- Arabic RTL remains accessible.
