# Localization and Internationalization

Use this guide when building multilingual Flutter apps, especially AR/EN, RTL, or store-localized releases.

## Defaults

- Use Flutter `gen_l10n` with ARB files.
- Keep all user-visible strings outside Dart widgets.
- Treat Arabic and English as first-class launch languages when the product targets MENA or global audiences.
- Test both LTR and RTL on real devices/emulators before release.

## Required structure

```text
lib/l10n/
  app_en.arb
  app_ar.arb
l10n.yaml
```

## Implementation rules

1. Add `flutter_localizations` and generated localization configuration.
2. Use `context.l10n` or an equivalent project extension.
3. Never concatenate translated fragments for user-facing sentences.
4. Use ICU plural/select syntax for counts, genders, roles, and statuses.
5. Format dates, times, numbers, currencies, and percentages with locale-aware APIs.
6. Keep brand/product names stable unless the localization strategy says otherwise.
7. Mirror directional layout with `Directionality`, `EdgeInsetsDirectional`, and `AlignmentDirectional`.
8. Avoid fixed-width text containers that break Arabic text.
9. Include localization keys in design QA and screenshot plans.

## Store localization checklist

- App title and subtitle/short description per locale.
- Full description per locale.
- Screenshot captions per locale.
- Keywords per locale where supported.
- Support/privacy URLs that work for all launch regions.
- Review notes in English, plus Arabic notes if the app requires Arabic-specific review context.

## QA checklist

- English small/large text.
- Arabic small/large text.
- Long strings and truncation.
- RTL navigation, icons, back gestures, forms, and charts.
- Empty/loading/error states in every supported locale.
- Push notification samples in every supported locale.
