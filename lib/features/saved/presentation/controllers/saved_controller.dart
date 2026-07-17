import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/saved_repository_impl.dart';
import '../../domain/entities/saved_item.dart';

final savedControllerProvider =
    NotifierProvider<SavedController, SavedState>(SavedController.new);

enum SavedStatus { loading, success, empty, error }

class SavedState {
  const SavedState({required this.status, this.items = const [], this.failure});

  const SavedState.loading() : this(status: SavedStatus.loading);
  const SavedState.empty() : this(status: SavedStatus.empty);
  const SavedState.success(List<SavedItem> items)
    : this(status: SavedStatus.success, items: items);
  const SavedState.error(AppFailure failure)
    : this(status: SavedStatus.error, failure: failure);

  final SavedStatus status;
  final List<SavedItem> items;
  final AppFailure? failure;
}

class SavedController extends Notifier<SavedState> {
  var _disposed = false;

  @override
  SavedState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const SavedState.loading();
  }

  Future<void> load() async {
    // The `/saved` endpoint is auth-only; a guest simply has nothing saved.
    final signedIn = ref.read(authControllerProvider).session != null;
    if (!signedIn) {
      state = const SavedState.empty();
      return;
    }

    state = const SavedState.loading();
    final result = await ref.read(savedRepositoryProvider).getSavedItems();
    if (_disposed) return;

    state = result.when(
      success: (items) =>
          items.isEmpty ? const SavedState.empty() : SavedState.success(items),
      failure: SavedState.error,
    );
  }

  Future<void> retry() => load();

  /// Optimistically drops the item, then calls `DELETE /saved/:id`. Reverts on
  /// failure.
  Future<void> remove(String savedId) async {
    final current = state;
    if (current.status != SavedStatus.success) return;

    final remaining =
        current.items.where((item) => item.id != savedId).toList();
    state = remaining.isEmpty
        ? const SavedState.empty()
        : SavedState.success(remaining);

    final result = await ref.read(savedRepositoryProvider).removeSavedItem(savedId);
    if (_disposed) return;

    result.when(
      success: (_) {},
      failure: (_) {
        // Restore the previous list on failure.
        state = current;
      },
    );
  }
}
