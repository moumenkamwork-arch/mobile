import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-shell screens can expose an extra "back layer" that is not a route
/// (e.g. Services: category results shown over the category grid). They
/// register a handler here; the shell's PopScope consults the registry
/// BEFORE its own tab/exit handling, so the system back button unwinds
/// screen-internal layers first — one step at a time.
final backInterceptorsProvider = Provider<BackInterceptorRegistry>((ref) {
  return BackInterceptorRegistry();
});

/// A handler returns true when it consumed the back press.
typedef BackInterceptor = bool Function();

class BackInterceptorRegistry {
  final List<BackInterceptor> _handlers = [];

  /// Registers [handler]; returns a callback that unregisters it.
  VoidCallback register(BackInterceptor handler) {
    _handlers.add(handler);
    return () => _handlers.remove(handler);
  }

  /// Gives the most recently registered handler the first chance.
  bool handle() {
    for (final handler in _handlers.reversed.toList(growable: false)) {
      if (handler()) {
        return true;
      }
    }
    return false;
  }
}
