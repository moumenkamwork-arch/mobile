import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_content.dart';

final homeContentDetailControllerProvider =
    NotifierProvider.family<
      HomeContentDetailController,
      HomeContentDetailState,
      HomeContentDetailRequest
    >(HomeContentDetailController.new);

enum HomeContentDetailStatus { loading, success, error }

class HomeContentDetailState {
  const HomeContentDetailState({
    required this.status,
    this.detail,
    this.failure,
  });

  const HomeContentDetailState.loading()
    : this(status: HomeContentDetailStatus.loading);

  const HomeContentDetailState.success(HomeContentDetail detail)
    : this(status: HomeContentDetailStatus.success, detail: detail);

  const HomeContentDetailState.error(AppFailure failure)
    : this(status: HomeContentDetailStatus.error, failure: failure);

  final HomeContentDetailStatus status;
  final HomeContentDetail? detail;
  final AppFailure? failure;
}

class HomeContentDetailController extends Notifier<HomeContentDetailState> {
  HomeContentDetailController(this.request);

  final HomeContentDetailRequest request;
  var _disposed = false;

  @override
  HomeContentDetailState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const HomeContentDetailState.loading();
  }

  Future<void> load() async {
    if (!request.isValid) {
      state = const HomeContentDetailState.error(
        AppFailure.validation(message: 'Home detail is unavailable.'),
      );
      return;
    }

    state = const HomeContentDetailState.loading();
    final result = await ref
        .read(homeRepositoryProvider)
        .getHomeContentDetail(request);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: HomeContentDetailState.success,
      failure: HomeContentDetailState.error,
    );
  }

  Future<void> retry() {
    return load();
  }
}
