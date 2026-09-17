# Example App Spec: Marketplace

## Product idea

A two-sided marketplace where buyers discover services and sellers manage listings, orders, and messages.

## MVP features

- Auth and onboarding.
- Buyer home/search/filter.
- Listing details.
- Seller listing management.
- Order request flow.
- Messaging placeholder or integration seam.
- Profile/settings.
- Notifications/deep links placeholder.

## Architecture notes

- Features: auth, buyer_home, listings, seller_dashboard, orders, messages, profile.
- Use repositories for listings/orders/messages.
- Use typed failures for network/auth/payment errors.
- Add fake repositories for UI tests before backend is ready.

## Launch notes

- Review UGC/moderation needs.
- Prepare privacy matrix for profiles, messages, location, payments.
- Prepare store screenshots for buyer and seller journeys.
