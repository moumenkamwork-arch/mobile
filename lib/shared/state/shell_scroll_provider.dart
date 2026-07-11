import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the current shell tab's body has scrolled past the top.
///
/// The shell updates this from the single scroll listener it already runs for
/// the bottom navigation, so the in-shell page header ([PromooPageHeader]) can
/// show the same translucent "glass" state as the footer instead of staying a
/// flat opaque bar. Reset to `false` on every tab change (each tab opens at the
/// top).
class ShellScrollController extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool scrolled) {
    if (state != scrolled) {
      state = scrolled;
    }
  }
}

final shellScrolledProvider = NotifierProvider<ShellScrollController, bool>(
  ShellScrollController.new,
);
