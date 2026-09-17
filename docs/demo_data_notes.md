# Promoo demo data notes

Last updated: 2026-07-02

## Purpose

The mock-mode data is fictional presentation content for client review. It is used only when the app runs with:

```powershell
--dart-define=PROMOO_USE_MOCKS=true
```

Production data should come from the backend through the existing repository/data-source boundaries.

The client-review APK must be built with:

```powershell
--dart-define=PROMOO_USE_MOCKS=true
```

## Data strategy

- Keep all presentation data behind fake data sources, DTO fixtures, or clearly named demo helpers.
- Do not place fake business data directly inside widgets.
- Use AED as the only mock-mode currency.
- Use fictional UAE/GCC-friendly profile, provider, campaign, service, seat, chat, and notification content.
- Avoid real brands, celebrities, people, phone numbers, emails, and private information.
- Avoid visible placeholder wording in app content.
- Use professional-looking image URLs for Home stories, offers, Promoo of the Day, service previews, Cup profiles, Profile media, and Influencer seat holders, with in-app fallback rendering if a network image fails.
- Use professional-looking image URLs for Services category cards and service listing/detail cards; icons are fallback only.
- Do not bundle old prototype screenshots or visual reference screenshots as app assets.
- Android client-review launcher icons are generated from the supplied PROMOO brand logo and can be replaced later by final production brand exports.

## Consistency map

| Area | Primary fictional data |
| --- | --- |
| Main profile/provider | Saffron Social Studio, `profile-saffron-social` |
| Main service | Boutique influencer launch package, `service-influencer-launch`, 2200 AED |
| Top offer | Cafe opening spotlight, `offer-1`, 1500 AED |
| For You offers | Creator campaign pick, Flash offer 24H, and Featured campaign spotlight |
| Promoo of the Day | Boutique launch visibility pack, `offer-featured`, 2200 AED |
| Home stories | Maya Studio, Omar Visuals, Lina Atelier, Pearl District, and CalmFit grouped story previews with three owner-level items each |
| Home service swiper | Boutique influencer launch, product photography, cafe promotion, wellness awareness, and styling content services |
| Services categories | Image-led Beauty & Wellness, Restaurants & Cafes, Events & Photography, Fashion & Styling, Health & Fitness, Home & Lifestyle, Digital Marketing, and Influencer Campaigns categories |
| Leaderboard | Saffron Social Studio, Lina Atelier, Framehouse Events, Pearl District Cafe, Velvet Beauty Lounge, with profile-route-aligned IDs |
| Profile media/stats | Image-led Saffron Social Studio media plus fictional Followers, Likes, Posts, and Views behind `ProfileFakeDataSource` |
| Influencer seats | Dense Gold/Silver/Bronze visibility placements priced in AED, including occupied, pending, and available states |
| Chat/notifications | Campaign, package, profile-view, and offer-interest copy tied to the same fictional providers |

## Replacement plan

The next backend-integration hardening phase should replace mock-mode content with backend responses per vertical slice while preserving:

- defensive DTO parsing
- typed failures
- loading/error/empty states
- current routes and screen structure
- AED fallback only when the backend omits currency
