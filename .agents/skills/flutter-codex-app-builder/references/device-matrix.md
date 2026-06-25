# Device and Platform Matrix

Use this matrix before release or when a feature is UI/performance sensitive.

## Minimum release matrix

- Android low-end device or emulator.
- Android mid-range/current device.
- Android latest API emulator.
- Small iPhone.
- Large iPhone/Pro Max.
- iPad if tablet supported.
- Android tablet if tablet supported.
- Desktop browser if Flutter Web is supported.
- Mobile browser if Flutter Web is supported.

## What to test per device

1. Install/upgrade path.
2. First launch and cold start.
3. Auth/onboarding.
4. Primary user journey.
5. Offline/slow network.
6. Push notification/deep link if relevant.
7. Payment/subscription if relevant.
8. Locale and RTL if relevant.
9. Accessibility text scaling.
10. Crash-free smoke test.

## Performance-sensitive gates

- Startup time acceptable for target market.
- List scrolling does not jank.
- Large images are optimized.
- Memory does not grow after repeated navigation.
- App size is reviewed before production.
