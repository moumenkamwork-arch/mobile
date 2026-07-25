import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shell/promoo_shell.dart';

/// Guards the bottom-nav layout + selected-index resolution.
///
/// The bar is identical for every role: Home, Influencer (Seats), Promoo,
/// Services, Profile. There is no standalone Offers tab — everyone can open
/// the Influencer tab, but what it shows once inside is role-gated in
/// `SeatsScreen`, not here.
void main() {
  int indexForPath(List<PromooShellTab> tabs, String path) {
    final id = selectedShellTabForPath(path);
    return tabs.indexWhere((tab) => tab.id == id);
  }

  group('5-tab bar (same for every role)', () {
    final tabs = PromooShell.tabs;

    test('has 5 tabs in the expected order', () {
      expect(tabs.length, 5);
      expect(
        tabs.map((t) => t.id).toList(),
        const [
          PromooShellTabId.home,
          PromooShellTabId.influencer,
          PromooShellTabId.promoo,
          PromooShellTabId.services,
          PromooShellTabId.profile,
        ],
      );
    });

    test('has no standalone Offers tab', () {
      expect(tabs.any((t) => t.id == PromooShellTabId.offers), isFalse);
    });

    test('each route resolves to its real index', () {
      expect(indexForPath(tabs, AppRoutes.home), 0);
      expect(indexForPath(tabs, AppRoutes.seats), 1);
      expect(indexForPath(tabs, AppRoutes.cup), 2);
      expect(indexForPath(tabs, AppRoutes.services), 3);
      expect(indexForPath(tabs, AppRoutes.profile), 4);
    });
  });
}
