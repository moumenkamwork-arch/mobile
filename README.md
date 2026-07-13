<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/brand/new_logo/promoo_wordmark.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/brand/new_logo/promoo_wordmark_light.png">
  <img src="assets/brand/new_logo/promoo_wordmark.png" alt="Promoo" width="320">
</picture>

### The premium marketplace for companies, influencers & service providers

Discover offers · Book influencer "seats" · Promote with ads · Climb the Cup leaderboard

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State management](https://img.shields.io/badge/State-Riverpod-4CAF50)](https://riverpod.dev)
[![Localization](https://img.shields.io/badge/i18n-Arabic%20%2F%20English-FFE604?labelColor=000000)](#-localization)
[![Tests](https://img.shields.io/badge/tests-176%20passing-brightgreen)](#-testing)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)](#)

</div>

---

## ✨ What is Promoo?

**Promoo** is a bold, dark-and-yellow marketplace app that connects four kinds of people in one place:

| Who | What they do on Promoo |
| --- | --- |
| 🏢 **Companies** | Publish offers, run ads, get discovered |
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
Role-gated "Add Offer", "Add Service", and a 4-step "Add Ad" wizard — each mapped 1:1 to its backend payload.

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
| Testing | `flutter_test` — **176 widget/unit tests**, zero `flutter analyze` warnings |

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
│   ├── profile/                # Public profile, settings, edit, add-offer/ad/service wizards
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

Every repository is backed by a fake/local data source today (see [Status & Roadmap](#-status--roadmap)) but is shaped 1:1 against the real backend contract, so wiring a real network layer back in is a scoped, per-feature change — not a rewrite.

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

# Runs entirely on local/fake data — no backend required
flutter run --dart-define=PROMOO_USE_MOCKS=true
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

**176 tests**, covering controllers, repositories, and full widget flows — including dedicated `*_l10n_test.dart` suites that prove every localized screen renders correct Arabic text while asserting the layout stays fixed left-to-right.

---

## 🗺️ Status & Roadmap

Promoo is built **frontend-first**: the entire app is complete against a real backend API contract, currently running on local fake data sources so the UI can be demoed and iterated on independently.

- ✅ **Phase A — Frontend** — every screen, flow, theme, and the full Arabic/English localization pass are complete.
- 🔜 **Phase B — Integration** — wiring each feature to the live REST API (auth, follows, uploads, payments, push notifications) is next, one feature at a time.

---

<div align="center">

Built with Flutter · Designed in black & yellow · Made bilingual from day one

</div>
