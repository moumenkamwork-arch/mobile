import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

/// Which content-creation actions the signed-in account may perform, derived
/// from its `account_type`. This mirrors the backend's `requireAccountType`
/// guards exactly, so the UI only ever offers actions the API would accept —
/// no user is shown a control that would return `403 Forbidden`.
///
/// Backend rules (see `docs/roles_logic.md`):
/// - **Offers**  → `company`, `service_provider`, `influencer`
/// - **Services**→ `company`, `service_provider`
/// - **Book seat**→ `influencer`
///
/// Ads were dropped from the app entirely (v1 scope is Offers + Services
/// only, per the original client design) — `influencer`, who used to only
/// get Ads, now publishes via Offers instead.
///
/// A guest (no session) or a regular `user` can create nothing.
class AccountCapabilities {
  const AccountCapabilities(this.accountType);

  final AuthAccountType? accountType;

  bool get canAddOffer =>
      accountType == AuthAccountType.company ||
      accountType == AuthAccountType.serviceProvider ||
      accountType == AuthAccountType.influencer;

  bool get canAddService =>
      accountType == AuthAccountType.company ||
      accountType == AuthAccountType.serviceProvider;

  bool get canBookSeat => accountType == AuthAccountType.influencer;

  /// True when at least one creation action is available — used to decide
  /// whether to render the "create" group at all.
  bool get canCreateAnything => canAddOffer || canAddService;
}

/// Reads the current session's `account_type` and exposes the derived
/// creation permissions. Recomputes whenever auth state changes (login,
/// logout, register), so the Profile menu re-gates automatically.
final accountCapabilitiesProvider = Provider<AccountCapabilities>((ref) {
  final session = ref.watch(authControllerProvider).session;
  return AccountCapabilities(session?.user.accountType);
});
