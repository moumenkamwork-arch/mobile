# Performance and App Size Pack

Use this for startup time, jank, memory, network efficiency, image optimization, and release build size.

## Performance workflow

1. Reproduce the issue on profile/release mode when possible.
2. Measure before optimizing.
3. Use Flutter DevTools or platform profilers for frame rendering, memory, CPU, and network.
4. Fix the largest measurable bottleneck first.
5. Add a regression check or documented guardrail.

## Flutter performance checklist

- Avoid heavy work in `build` methods.
- Use const constructors where helpful.
- Split widgets to reduce rebuild scope.
- Use Riverpod selectors or scoped providers for expensive state.
- Paginate large lists and use lazy builders.
- Optimize images: correct dimensions, caching, compression, placeholders.
- Move CPU-heavy work to isolates when appropriate.
- Avoid unnecessary opacity/clipping/shadow effects in long lists.
- Test dark mode and text scaling for layout overflow.

## App size checklist

- Build release artifacts, not debug artifacts.
- Analyze unused assets and oversized images.
- Enable Android code/resource shrinking where safe.
- Consider Dart obfuscation with split debug info for release.
- Review native SDK size impact before adding packages.
- Avoid bundling large local datasets unless required.

## Startup checklist

- Keep synchronous work in `main()` minimal.
- Lazy-load non-critical SDKs after first frame where safe.
- Show a meaningful splash/loading state.
- Fail gracefully if remote config/analytics/crash SDKs are unavailable.
