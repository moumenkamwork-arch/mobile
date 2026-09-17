import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/profile/presentation/controllers/account_capabilities.dart';

void main() {
  group('AccountCapabilities mirrors backend requireAccountType guards', () {
    test('company can add offer and service', () {
      const caps = AccountCapabilities(AuthAccountType.company);
      expect(caps.canAddOffer, isTrue);
      expect(caps.canAddService, isTrue);
      expect(caps.canBookSeat, isFalse);
      expect(caps.canCreateAnything, isTrue);
    });

    test('service_provider can add offer + service', () {
      const caps = AccountCapabilities(AuthAccountType.serviceProvider);
      expect(caps.canAddOffer, isTrue);
      expect(caps.canAddService, isTrue);
      expect(caps.canBookSeat, isFalse);
    });

    test('influencer can add offer + book seat only', () {
      const caps = AccountCapabilities(AuthAccountType.influencer);
      expect(caps.canAddOffer, isTrue);
      expect(caps.canBookSeat, isTrue);
      expect(caps.canAddService, isFalse);
    });

    test('regular user can create nothing', () {
      const caps = AccountCapabilities(AuthAccountType.user);
      expect(caps.canCreateAnything, isFalse);
      expect(caps.canBookSeat, isFalse);
    });

    test('guest (no session) can create nothing', () {
      const caps = AccountCapabilities(null);
      expect(caps.canAddOffer, isFalse);
      expect(caps.canAddService, isFalse);
      expect(caps.canBookSeat, isFalse);
      expect(caps.canCreateAnything, isFalse);
    });
  });
}
