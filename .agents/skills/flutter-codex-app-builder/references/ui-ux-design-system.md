# Flutter UI/UX design system reference

Use this reference for screens, landing pages, dashboards, visual redesigns, component systems, accessibility, and UI reviews.

## Design system workflow

1. Classify the product: domain, audience, trust level, conversion goal, data density, platform targets, and brand mood.
2. Pick a page pattern: hero-centric, conversion-optimized, feature-rich showcase, minimal/direct, social-proof, interactive demo, trust/authority, storytelling, or dashboard pattern.
3. Pick style priorities from the style catalog below. Avoid mixing more than two dominant styles.
4. Generate tokens: color roles, typography scale, spacing, radius, elevation, borders, motion duration, icon style, and chart palette.
5. Define components: app shell, navigation, cards, forms, buttons, list items, empty/error states, dialogs, toasts/snackbars, charts, tables, and loading skeletons.
6. Define anti-patterns: styles, colors, effects, copy, density, and interactions to avoid for the product category.
7. Persist rules in `design-system/MASTER.md`; add `design-system/pages/<page>.md` only for page-specific overrides.
8. Implement Flutter code using theme extensions, tokens, reusable widgets, semantic labels, responsive constraints, and reduced-motion handling.
9. Run pre-delivery checks before final response.

## Product reasoning categories

Use these categories to bias style, tone, interaction, and trust signals:

- tech and saas: saas, micro-saas, developer tools, ai/chatbot platforms, cybersecurity.
- finance: banking, fintech, crypto, insurance, personal finance, invoices/billing.
- healthcare: clinic, pharmacy, dental, veterinary, mental health, medication reminders.
- e-commerce: general shop, luxury, marketplace, subscription box, food delivery.
- services: spa/beauty, restaurant, hotel, legal, home services, booking/appointments.
- creative: portfolio, agency, photography, gaming, music, photo/video editing.
- lifestyle: habit tracker, recipes, meditation, weather, diary, mood tracking.
- emerging tech: web3/nft, spatial computing, quantum computing, autonomous systems.

Each category should produce a recommended pattern, style priority, color mood, typography mood, key effects, and anti-pattern list.

## Style catalog

General UI styles:

1. Minimalism and Swiss style - enterprise, dashboards, documentation.
2. Neumorphism - wellness, meditation, calm consumer apps.
3. Glassmorphism - modern SaaS and financial dashboards.
4. Brutalism - design portfolios and artistic projects.
5. 3D and hyperrealism - games, product showcases, immersive commerce.
6. Vibrant block-based - startups, creative agencies, gaming.
7. Dark OLED mode - night apps, coding platforms, pro tools.
8. Accessible and ethical - government, healthcare, education.
9. Claymorphism - education, kids, friendly SaaS.
10. Aurora UI - modern SaaS and creative agencies.
11. Retro-futurism - gaming, entertainment, music.
12. Flat design - web apps, mobile apps, MVPs.
13. Skeuomorphism - legacy, gaming, premium tactile products.
14. Liquid glass - premium SaaS and high-end commerce.
15. Motion-driven - portfolios and storytelling.
16. Micro-interactions - mobile and touch-first UIs.
17. Inclusive design - public services, education, healthcare.
18. Zero interface - voice assistants and AI platforms.
19. Soft UI evolution - enterprise apps and SaaS.
20. Neubrutalism - Gen Z brands and startup landing pages.
21. Bento box grid - dashboards, product pages, portfolios.
22. Y2K aesthetic - fashion, music, youth products.
23. Cyberpunk UI - games, cybersecurity, crypto.
24. Organic biophilic - wellness, sustainability, biotech.
25. AI-native UI - AI products, copilots, chatbots.
26. Memphis design - creative agencies, music, youth brands.
27. Vaporwave - music, gaming, portfolios.
28. Dimensional layering - cards, modals, dashboard layouts.
29. Exaggerated minimalism - fashion, architecture, portfolios.
30. Kinetic typography - hero sections and marketing.
31. Parallax storytelling - product launches and brands.
32. Swiss modernism 2.0 - corporate, architecture, editorial.
33. HUD / sci-fi FUI - space, security, sci-fi apps.
34. Pixel art - indie games and retro tools.
35. Bento grids - features, dashboards, personal sites.
36. Spatial UI - AR/VR/spatial computing.
37. E-ink / paper - reading and newspaper apps.
38. Gen Z chaos / maximalism - music and lifestyle.
39. Biomimetic organic 2.0 - sustainability, biotech, health.
40. Anti-polish / raw aesthetic - artists and creative portfolios.
41. Tactile digital / deformable UI - playful mobile brands.
42. Nature distilled - wellness and sustainable products.
43. Interactive cursor design - creative portfolios and web experiences.
44. Voice-first multimodal - voice assistants and accessibility.
45. 3D product preview - furniture, fashion, e-commerce.
46. Gradient mesh / aurora evolved - hero backgrounds and creative apps.
47. Editorial grid / magazine - news, blogs, editorial products.
48. Chromatic aberration / RGB split - gaming, music, tech.
49. Vintage analog / retro film - photography, vinyl, music brands.

Landing page patterns:

- Hero-centric design, conversion-optimized, feature-rich showcase, minimal/direct, social-proof focused, interactive product demo, trust/authority, storytelling-driven.

BI/dashboard styles:

- Data-dense dashboard, heat map dashboard, executive dashboard, real-time monitoring, drill-down analytics, comparative analysis, predictive analytics, user behavior analytics, financial dashboard, sales intelligence dashboard.

## Flutter implementation rules

- Map design tokens to `ThemeData`, `ColorScheme`, `TextTheme`, and custom `ThemeExtension`s.
- Keep colors semantic: primary, secondary, surface, background, error, success, warning, info, outline, muted, accent, chart series.
- Prefer `LayoutBuilder`, breakpoints, max-width constraints, slivers, adaptive navigation, and responsive typography.
- Use reusable components: `AppScaffold`, `ResponsiveContainer`, `AppCard`, `PrimaryActionButton`, `EmptyState`, `ErrorState`, `LoadingSkeleton`, `MetricCard`, `ChartShell`.
- Use SVG/vector icons or Flutter icon libraries. Do not use emojis as core icons.
- Use 150-300ms motion for hover/press transitions. Respect reduced motion and avoid heavy animation on low-end devices.
- Ensure tap targets are at least 44x44 logical pixels.
- Ensure text contrast is at least WCAG AA, especially in light mode and on gradients.
- Support text scaling, screen readers, keyboard traversal, and focus states.
- For dashboards, design empty/filter/loading/error states for every chart and table.

## 25 chart recommendation types

Use charts only when they answer a user question. Choose from: line, area, stacked area, bar, stacked bar, grouped bar, horizontal bar, pie, donut, scatter, bubble, heatmap, calendar heatmap, treemap, radar, gauge, funnel, waterfall, candlestick, box plot, histogram, choropleth/map, sankey, network graph, and KPI/metric card.

## Design-system output template

```markdown
# [project] design system

## Product reasoning
- category:
- audience:
- trust/conversion goal:
- platform targets:

## Recommended pattern
- layout pattern:
- core sections:
- cta strategy:

## Style direction
- primary style:
- secondary style:
- why this fits:
- avoid:

## Tokens
- colors:
- typography:
- spacing:
- radius:
- elevation:
- motion:
- iconography:

## Components
- shell/navigation:
- cards:
- forms:
- buttons:
- data visualization:
- states:

## Accessibility and performance
- contrast:
- text scaling:
- semantics:
- keyboard/focus:
- reduced motion:
- render/performance:

## Page overrides
- use `design-system/pages/<page>.md` for page-specific deviations only.
```

## Master plus overrides retrieval

When building a page:

1. Read `design-system/MASTER.md` first.
2. Check for `design-system/pages/<page>.md`.
3. If the page file exists, use it only for deviations from master.
4. If no page file exists, use master rules exclusively.

## UI anti-patterns

- Generic AI purple/pink gradients for finance, healthcare, government, or enterprise trust products.
- Low contrast on glass/gradient surfaces.
- Emoji icons in production navigation or professional dashboards.
- Fixed mobile-only layouts for apps that target tablet/web.
- Animation without reduced-motion fallback.
- Dashboard charts with no labels, legends, empty state, or data freshness.
- Forms with no validation, helper text, focus order, or error recovery.
- Beautiful screens that lack loading, empty, error, offline, permission, and retry states.
