import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/routing/route_names.dart';
import 'package:promoo_app/shell/promoo_shell.dart';

/// Guards the role-aware bottom-nav layout + selected-index resolution.
///
/// Regression: the Seats tab is shown to influencers AND companies, expanding
/// the bar to 6 tabs. A stale static path→index map (`/services => 3`) had been
/// left behind, so on a 6-tab bar the wrong tab highlighted (Services is index
/// 4 there, not 3). The shell now resolves the index against the actual
/// role-aware tab list — these tests lock that in for both bar sizes.
void main() {
  int indexForPath(List<PromooShellTab> tabs, String path) {
    final id = selectedShellTabForPath(path);
    return tabs.indexWhere((tab) => tab.id == id);
  }

  group('6-tab bar (influencer / company — can view Seats)', () {
    final tabs = PromooShell.tabsFor(canViewSeats: true);

    test('has 6 tabs in the expected order', () {
      expect(tabs.length, 6);
      expect(
        tabs.map((t) => t.id).toList(),
        const [
          PromooShellTabId.home,
          PromooShellTabId.offers,
          PromooShellTabId.influencer,
          PromooShellTabId.promoo,
          PromooShellTabId.services,
          PromooShellTabId.profile,
        ],
      );
    });

    test('each route resolves to its real index (not the stale 5-tab map)', () {
      expect(indexForPath(tabs, AppRoutes.home), 0);
      expect(indexForPath(tabs, AppRoutes.offers), 1);
      expect(indexForPath(tabs, AppRoutes.seats), 2);
      expect(indexForPath(tabs, AppRoutes.cup), 3);
      expect(indexForPath(tabs, AppRoutes.services), 4); // was wrongly 3
      expect(indexForPath(tabs, AppRoutes.profile), 5); // was wrongly 4
    });
  });

  group('5-tab bar (user / provider / guest — cannot view Seats)', () {
    final tabs = PromooShell.tabsFor(canViewSeats: false);

    test('has 5 tabs and no Seats/Influencer tab', () {
      expect(tabs.length, 5);
      expect(tabs.any((t) => t.id == PromooShellTabId.influencer), isFalse);
    });

    test('each route resolves to its real index', () {
      expect(indexForPath(tabs, AppRoutes.home), 0);
      expect(indexForPath(tabs, AppRoutes.offers), 1);
      expect(indexForPath(tabs, AppRoutes.cup), 2);
      expect(indexForPath(tabs, AppRoutes.services), 3);
      expect(indexForPath(tabs, AppRoutes.profile), 4);
    });
  });
}
