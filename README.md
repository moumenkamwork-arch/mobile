<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/brand/new_logo/promoo_wordmark.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/brand/new_logo/promoo_wordmark_light.png">
  <img src="assets/brand/new_logo/promoo_wordmark.png" alt="Promoo" width="320">
</picture>

### The premium marketplace for companies, influencers & service providers

Discover offers · Book influencer "seats" · Browse services · Climb the Cup leaderboard

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State management](https://img.shields.io/badge/State-Riverpod-4CAF50)](https://riverpod.dev)
[![Localization](https://img.shields.io/badge/i18n-Arabic%20%2F%20English-FFE604?labelColor=000000)](#-localization)
[![Tests](https://img.shields.io/badge/tests-196%20passing-brightgreen)](#-testing)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)](#)

</div>

---

## ✨ What is Promoo?

**Promoo** is a bold, dark-and-yellow marketplace app that connects four kinds of people in one place:

| Who | What they do on Promoo |
| --- | --- |
| 🏢 **Companies** | Publish offers, list services, get discovered |
| 🌟 **Influencers** | Book visibility "seats", grow their following, climb the Cup |
| 🛠️ **Service providers** | List services, manage packages, chat with clients |
| 🙋 **Users** | Browse offers & services, follow profiles, chat, save favorites |

Everything runs on a real, production-shaped backend contract (REST + Supabase), a clean-architecture Flutter codebase, and a fully bilingual (Arabic/English) interface designed from day one — not bolted on later.

---

## 🚀 Feature Tour

<table>
<tr>
<td width="50%" valign="top">

**🏠 Home**
Stories, curated "Top Offers" hero carousel, "For You" picks, and "Promoo of the Day" — each with its own See All view.

**🛍️ Services**
Searchable, category-driven marketplace with rich service detail pages (pricing, delivery time, provider contact).

**🎟️ Influencer Seats**
A 144-seat visibility grid across Gold / Silver / Bronze tiers, with live availability, tier legends, and a checkout preview flow.

**🏆 Cup — Leaderboard**
A gamified, follower-ranked podium + full leaderboard across companies, influencers, and service providers.

</td>
<td width="50%" valign="top">

**👤 Rich Profiles**
Instagram-style stats (Followers / Likes / Posts / Views), packages, media grid with a full-screen viewer, Follow/Message actions.

**💬 Chat & 🔔 Notifications**
1:1 conversations with live unread badges, delivery states, and a notifications center with mark-all-read.

**📝 Creation Wizards**
Role-gated "Add Offer" and "Add Service" flows — each mapped 1:1 to its backend payload, with inline validation matching the server's own rules.

**🎨 Theming & 🌍 Localization**
Full Black/Light theme toggle and complete Arabic/English translation — see below for the interesting part.

</td>
</tr>
</table>

---

## 🌍 Localization

Promoo ships **fully translated** into Arabic and English, switchable instantly from Settings and persisted across sessions.

A deliberate, non-default design choice: **the layout direction never mirrors.** Toggling to Arabic translates every string through 400+ ICU-aware ARB keys (with real plural and grammatical-order rules — e.g. Arabic's 6 CLDR plural forms, and adjective-noun word order fixed via ICU `select` instead of naive string concatenation) while the UI layout itself stays pinned left-to-right in both languages. Arabic script still renders correctly right-to-left at the character level (that's the Unicode bidi algorithm doing its job independently of layout) — only widget ordering stays fixed, by design.

```dart
// lib/app.dart
builder: (context, child) {
  return Directionality(
    textDirection: TextDirection.ltr, // always LTR — text translates, layout doesn't
    child: child,
  );
},
```

---

## 🧱 Tech Stack

| Layer | Choice |
| --- | --- |
| Framework | **Flutter** (Dart, null-safe) |
| State management | **Riverpod 3** (`Notifier` / `NotifierProvider.family`) |
| Routing | **go_router** — declarative, deep-link ready, role-gated |
| Architecture | Clean Architecture, **feature-first vertical slices** (`data` / `domain` / `presentation` per feature) |
| Error handling | Typed `Result<T, AppFailure>` — no exceptions leaking into the UI |
| Localization | Flutter `l10n` / ARB + `intl`, ICU `plural` & `select` |
| Design system | Centralized `ThemeExtension` tokens — colors, spacing, radius, typography |
| Testing | `flutter_test` — **196 widget/unit tests**, zero `flutter analyze` warnings |

---

## 🏗️ Architecture

Each feature is a self-contained vertical slice:

```
lib/
├── app.dart                  # MaterialApp.router root — theme, locale, LTR lock
├── features/
│   ├── auth/                 # Login, Register, guest access
│   ├── home/                 # Stories, offers, "For You", content detail
│   ├── services/              # Marketplace search + service detail
│   ├── seats/                 # Influencer seat grid + checkout preview
│   ├── leaderboard/            # Cup — podium + ranked list
│   ├── profile/                # Public profile, settings, edit, add-offer/service wizards
│   ├── chat/                  # Chat list + rooms
│   └── notifications/          # Notifications center
│       └── <feature>/
│           ├── data/          # DTOs + repository implementations + fake data sources
│           ├── domain/        # Entities + repository contracts
│           └── presentation/  # Screens, widgets, Riverpod controllers
├── shared/widgets/            # PromooButton, PromooCard, empty/error/loading states…
├── shell/                     # Bottom-nav shell, header, footer chrome
├── theme/                     # AppColors, AppThemeColors, spacing, radius, typography
├── i18n/                      # Locale controller
├── l10n/                      # Generated AppLocalizations + ARB source files
└── routing/                   # go_router config + route names
```

Every repository is wired to the real backend contract over REST (Dio + a typed `Result<T, AppFailure>`), with a fake/local data source kept alongside each one purely for widget tests and offline demos — never the default at runtime.

---

## 🎨 Design System

| Token | Dark | Light |
| --- | --- | --- |
| Brand | `#000000` black | `#F7F6F1` warm paper |
| Accent | `#FFE604` brand yellow | `#7A6900` AA-contrast gold |
| Typography | **Tajawal** (UI, bundled, Arabic + Latin) · **Varela Round** (logo only) | |

Yellow is always a *fill* (black content on top); as body/ink text it uses a dedicated `accent` token so it stays readable (and AA-compliant) in both themes.

---

## 📦 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- A configured iOS/Android toolchain, or just a browser for web

### Run it

```bash
git clone <this-repo-url>
cd promo_mobile
flutter pub get

# Point the app at your backend (defaults to http://localhost:3000/api/v1
# if you skip this — see .env.example for every variable, including Supabase)
cp .env.example .env

flutter run
```

### Useful commands

```bash
dart format .              # format
flutter analyze            # static analysis
flutter test                # run the test suite
flutter gen-l10n            # regenerate AppLocalizations after editing lib/l10n/*.arb
```

---

## 🧪 Testing

```bash
flutter test
```

**196 tests**, covering controllers, repositories, and full widget flows — including dedicated `*_l10n_test.dart` suites that prove every localized screen renders correct Arabic text while asserting the layout stays fixed left-to-right.

---

## 🗺️ Status & Roadmap

Promoo shipped **frontend-first**, then wired feature-by-feature to the live backend — the app now runs end to end against the real [Promoo API](../promo_backend), deployed and reachable, not local fake data.

- ✅ **Phase A — Frontend** — every screen, flow, theme, and the full Arabic/English localization pass, complete.
- ✅ **Phase B — Integration** — every feature (auth, follows, chat, uploads, payments, push notifications, realtime) wired to the live REST API + Supabase Realtime.
- 🔜 **Store release** — Android signing + Play Console listing in progress; iOS pending a build machine (Codemagic/Mac).

---

<div align="center">

Built with Flutter · Designed in black & yellow · Made bilingual from day one

</div>
