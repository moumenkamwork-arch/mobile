import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../i18n/locale_controller.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_content.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

enum HomeStatus { loading, success, empty, error, refreshing }

class HomeState {
  const HomeState({required this.status, this.content, this.failure});

  const HomeState.loading() : this(status: HomeStatus.loading);

  const HomeState.success(HomeContent content)
    : this(status: HomeStatus.success, content: content);

  const HomeState.empty(HomeContent content)
    : this(status: HomeStatus.empty, content: content);

  const HomeState.error(AppFailure failure, {HomeContent? content})
    : this(status: HomeStatus.error, failure: failure, content: content);

  const HomeState.refreshing(HomeContent? content)
    : this(status: HomeStatus.refreshing, content: content);

  final HomeStatus status;
  final HomeContent? content;
  final AppFailure? failure;

  bool get isLoading => status == HomeStatus.loading;

  bool get isRefreshing => status == HomeStatus.refreshing;
}

class HomeController extends Notifier<HomeState> {
  var _disposed = false;

  @override
  HomeState build() {
    // Home's categories carry a single server-resolved `name` (via
    // Accept-Language) — watching the locale forces a full rebuild (fresh
    // fetch) whenever the language toggle changes, instead of leaving this
    // controller's one-time fetch frozen in whatever language was active on
    // first load.
    ref.watch(localeProvider);
    // `build()` reruns (same instance, see class docs) whenever the locale
    // changes, since a plain Notifier is never recreated on a watched-value
    // change — only the state is reset. `_disposed` must be reset here too,
    // otherwise the *previous* build's onDispose (fired right before this
    // rerun) leaves it permanently `true`, silently dropping every future
    // `_load()` result forever after the first locale switch.
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const HomeState.loading();
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return load();
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final previousContent = state.content;

    if (refreshing) {
      state = HomeState.refreshing(previousContent);
    } else if (showLoading) {
      state = const HomeState.loading();
    }

    final result = await ref.read(homeRepositoryProvider).getHomeContent();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (content) {
        if (content.isEmpty) {
          return HomeState.empty(content);
        }
        return HomeState.success(content);
      },
      failure: (failure) {
        return HomeState.error(
          failure,
          content: refreshing ? previousContent : null,
        );
      },
    );
  }
}
