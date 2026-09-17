# Promoo — v1 Interim Admin Curation (Stripe stand-ins)

Last updated: 2026-07-14 (offer featuring = Promoo of the Day + Top Offers, AND featured profiles — both implemented AND live-verified end-to-end)

> **What this file is.** The authoritative list of features that are **paid / Stripe-gated
> in the real (v2) design**, but in **v1 are driven manually from the dashboard** as a
> stand-in until Stripe is turned on. This is the *mirror image* of
> [`v2_deferred_scope.md`](v2_deferred_scope.md): that doc says "what we hide / don't build";
> this doc says "what we operate by hand in the meantime."
>
> **The core idea.** For every one of these features, Stripe's only real job is to **flip a
> flag** (`offers.is_featured = true`, insert a `featured_accounts` row, set an ad's
> `status = active`, …). The mobile app never sees Stripe — it just reads that flag. So an
> **admin flipping the same flag by hand produces the identical end state**, minus the
> payment. That's why these are *low-risk stand-ins, not throwaway hacks*: when v2 turns on
> Stripe, we **keep** the admin control (as a permanent override) and simply **add** the paid
> path next to it — we never rip anything out.
>
> **Golden rule reminder:** the real Stripe flows are already **built and working** on the
> backend (checkout → webhook → flips the flag). They are "off" in v1 only because the mobile
> checkout surface is deferred to v2 (see `v2_deferred_scope.md` §2). We are not replacing
> them — we are giving the operator a manual door to the same room.

---

## 1. Live now — implemented interim toggles

| Feature | Real v2 mechanism | v1 interim mechanism | Flag / table it writes | At v2 |
| --- | --- | --- | --- | --- |
| **Promoo of the Day** + **Top Offers** | `POST /offers/:id/feature` → Stripe checkout → webhook sets `offers.is_featured = true` (`subscription.service.ts`) | Dashboard → **Content → Offers → ⋯ → "Feature"** toggle (star). Endpoint: `PATCH /admin/content/offers/:id/feature` `{is_featured}` (`admin/content.service.ts:setOfferFeatured`) | `offers.is_featured` (boolean, already exists) | Keep the admin toggle as an operator override; add the paid self-serve path back for owners. No mobile change. |
| **Featured profiles** (the "Featured profiles" row on mobile Home) | `POST /featured` → Stripe checkout → webhook inserts a `featured_accounts` row (`placement='home'`) | Dashboard → **Users → ⋯ → "Feature on home"** toggle (star). Endpoint: `PATCH /admin/users/:id/feature-home` `{is_featured}` (`admin/user.service.ts:setProfileFeaturedHome`) — inserts/deactivates a `featured_accounts` row (placement `home`, open-ended window, `amount_paid=0`) for record-keeping, **and sets `profiles.is_featured` directly** in the same call | `featured_accounts` (table exists) + `profiles.is_featured` (set directly by the admin endpoint) | Keep the admin toggle as an override; add the paid path (webhook keeps using the DB trigger, which is fine for that flow — see bug note below). No mobile change (Home already reads `featured_profiles` from `GET /home`). |

**Why one toggle covers both sections** (owner decision 2026-07-14, "Option A — coupled"):
the offers list is returned sorted `is_featured DESC, created_at DESC` (`offer.service.ts`).
So featuring an offer makes it **float into the top 5 → the "Top Offers" hero band**, and the
**newest featured offer becomes "Promoo of the Day"** (the single hero highlight). One flag,
both surfaces — no schema change. If the client later wants them curated **independently**,
that's a one-column migration (`offers.is_top_offer`) + a second toggle — deliberately *not*
done in v1.

**Mobile side:** zero changes needed. `HomeContentDto` already reads `is_featured` /
`promoo_of_the_day` / `latest_offers` defensively. Wired live in Phase 4 (see
`integration_map.md` §3.2). To see it work: feature an offer in the dashboard → reload the
mobile Home → that offer appears as Promoo of the Day and in Top Offers.

**Live-verified end-to-end, 2026-07-14** (via the dashboard preview at `localhost:5174` and
the mobile web preview at `localhost:8765`, both against the real Supabase project):
- Offer feature toggle: clicked **Content → Offers → ⋯ → Feature** on a seeded demo offer →
  `PATCH /admin/content/offers/:id/feature` returned `is_featured: true` → reloaded mobile
  Home → the offer appeared as both the "Top offer" hero card in Top Offers **and** the
  "Promoo of the Day" card, confirming the single-flag design.
- Featured-profile toggle: clicked **Users → ⋯ → Feature on home** → reloaded mobile Home →
  `GET /home`'s `featured_profiles` array contained the profile.

**Bug found + fixed while live-verifying the profile toggle:** the endpoint originally relied
entirely on the `on_featured_account_change` DB trigger (see `009_create_payments_and_featured.sql`)
to sync `profiles.is_featured` after inserting the `featured_accounts` row. The trigger only
flips the flag when `now() between start_date and end_date` at the moment the row is
written — in practice the toggle silently no-opped (insert succeeded, `is_featured` stayed
`false`). Root cause not fully pinned down (most likely a timestamp/window edge case), but
regardless: an **admin override has no "payment window" to wait on**, so
`setProfileFeaturedHome` (`admin/user.service.ts`) now sets `profiles.is_featured` directly
in the same call, instead of depending on the trigger. The trigger is untouched and still
covers the real v2 Stripe webhook path (where the timing is naturally correct since the row
is written right when the paid window begins). The `featured_accounts` insert/deactivate is
kept for record-keeping.

---

## 2. Already covered by existing admin actions (no new work — documented for completeness)

These are *also* "paid unlock in v2, manual in v1", but the manual admin path **already
existed** before this doc — nothing new was built, they're listed so the picture is complete.

| Feature | Real v2 mechanism | v1 interim mechanism (already built) | Flag it writes |
| --- | --- | --- | --- |
| **Ad activation** (an ad is created `pending`, needs payment to go `active`) | Ad payment → webhook sets `status = active` | Dashboard → **Content → Ads → ⋯ → status → Active** (`PATCH /admin/content/ads/:id/status`) | `ads.status` |
| **Verified badge** (normally a Premium-subscription perk) | Subscription → verified | Dashboard → **Users → ⋯ → Verify** (`PATCH /admin/users/:id/verify`) | `profiles.is_verified` |

---

## 3. Genuinely deferred — no interim stand-in (stays hidden in v1)

Listed so nobody tries to "fake" these — the mobile app already hides them, and a manual
stand-in would add risk for no v1 benefit. Full detail in `v2_deferred_scope.md`.

| Feature | Why no interim | Mobile v1 |
| --- | --- | --- |
| **Subscriptions** (Basic / Premium recurring billing) | No point faking recurring payment; the only user-visible perk (verified badge) is already covered by §2 | Hidden |
| **Content Packages** (99 / 149 / 249) | No backend entity at all | Display-only |
| **Seat booking** (influencer pays to occupy a Cup seat) | Tied to the deferred Stripe checkout; the 144-seat grid is now **read-wired live** (Phase 6 — `GET /seats`), booking stays v2. **Seats screen is visible to influencer + company** (companies browse to find/contract influencers), **booking is influencer-only** (`account_capabilities:canBookSeat`). Bottom nav = 6 tabs for influencer/company (Offers + Seats), 5 for everyone else. See [phase_6_seats_integration.md](phase_6_seats_integration.md). | Read-wired; booking deferred v2 |
| **Payment history** | Nothing to show | Hidden |

---

## 4. Cross-reference

- What is hidden / deferred: [`v2_deferred_scope.md`](v2_deferred_scope.md)
- How the mobile consumes these flags: [`integration_map.md`](integration_map.md) §3.2 (Home)
- Backend admin endpoints: `promo_backend/src/routes/admin/content.routes.ts` (offer feature), `.../admin/user.routes.ts` (profile feature-home)
- Dashboard UI: `promo_dashboard/src/pages/Content.tsx` (offers), `.../pages/Users.tsx` (profiles)
