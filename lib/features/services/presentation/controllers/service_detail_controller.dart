import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/services_repository_impl.dart';
import '../../domain/entities/promoo_service.dart';

// autoDispose: see chatRoomControllerProvider — without it, revisiting a
// service you already opened this session reuses its stale cached state
// instead of refetching current data.
final serviceDetailControllerProvider =
    NotifierProvider.autoDispose.family<
      ServiceDetailController,
      ServiceDetailState,
      String
    >(ServiceDetailController.new);

enum ServiceDetailStatus { loading, success, error }

class ServiceDetailState {
  const ServiceDetailState({required this.status, this.service, this.failure});

  const ServiceDetailState.loading()
    : this(status: ServiceDetailStatus.loading);

  const ServiceDetailState.success(PromooService service)
    : this(status: ServiceDetailStatus.success, service: service);

  const ServiceDetailState.error(AppFailure failure)
    : this(status: ServiceDetailStatus.error, failure: failure);

  final ServiceDetailStatus status;
  final PromooService? service;
  final AppFailure? failure;
}

class ServiceDetailController extends Notifier<ServiceDetailState> {
  ServiceDetailController(this.serviceId);

  final String serviceId;
  var _disposed = false;

  @override
  ServiceDetailState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const ServiceDetailState.loading();
  }

  Future<void> load() async {
    if (serviceId.trim().isEmpty) {
      state = const ServiceDetailState.error(
        AppFailure.validation(message: 'Service details are unavailable.'),
      );
      return;
    }

    state = const ServiceDetailState.loading();
    final result = await ref
        .read(servicesRepositoryProvider)
        .getServiceById(serviceId);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: ServiceDetailState.success,
      failure: ServiceDetailState.error,
    );
  }

  Future<void> retry() {
    return load();
  }
}
