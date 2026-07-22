import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A monotonic counter bumped by the network layer (`api_client.dart`'s
/// refresh interceptor) the moment it gives up refreshing an expired session
/// and clears the token store. The app root (`app.dart`) listens to it and,
/// on any bump, flips auth state to signed-out and bounces to Login.
///
/// This exists purely to decouple the two: the interceptor must NOT import the
/// auth controller (that would form an import cycle through the repository /
/// data source that the interceptor's Dio already backs). A neutral signal
/// keeps the dependency one-directional.
final sessionExpiredSignalProvider =
    NotifierProvider<SessionExpiredSignal, int>(SessionExpiredSignal.new);

class SessionExpiredSignal extends Notifier<int> {
  @override
  int build() => 0;

  /// Fire the signal. The app root reacts to the increment.
  void trigger() => state = state + 1;
}
