import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ads/data/repositories/ads_repository_impl.dart';
import '../../../ads/domain/entities/ad_listing.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../offers/data/repositories/offers_repository_impl.dart';
import '../../../offers/domain/entities/offer_listing.dart';
import '../../../services/data/repositories/services_repository_impl.dart';
import '../../../services/domain/entities/promoo_service.dart';

final myListingsControllerProvider =
    NotifierProvider<MyListingsController, MyListingsState>(
      MyListingsController.new,
    );

enum MyListingsStatus { loading, success, empty, error }

class MyListingsState {
  const MyListingsState({
    required this.status,
    this.offers = const [],
    this.services = const [],
    this.ads = const [],
    this.failure,
  });

  const MyListingsState.loading()
    : this(status: MyListingsStatus.loading);
  const MyListingsState.empty()
    : this(status: MyListingsStatus.empty);
  const MyListingsState.error(AppFailure failure)
    : this(status: MyListingsStatus.error, failure: failure);

  final MyListingsStatus status;
  final List<OfferListing> offers;
  final List<PromooService> services;
  final List<AdListing> ads;
  final AppFailure? failure;

  bool get isEmpty => offers.isEmpty && services.isEmpty && ads.isEmpty;

  MyListingsState copyWith({
    List<OfferListing>? offers,
    List<PromooService>? services,
    List<AdListing>? ads,
  }) {
    return MyListingsState(
      status: MyListingsStatus.success,
      offers: offers ?? this.offers,
      services: services ?? this.services,
      ads: ads ?? this.ads,
    );
  }
}

class MyListingsController extends Notifier<MyListingsState> {
  var _disposed = false;

  @override
  MyListingsState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(load));
    return const MyListingsState.loading();
  }

  Future<void> load() async {
    final userId = ref.read(authControllerProvider).session?.user.id;
    if (userId == null) {
      state = const MyListingsState.empty();
      return;
    }

    state = const MyListingsState.loading();

    // Kick off all three requests before awaiting any of them so they run
    // concurrently (each Future starts executing the moment it's created);
    // kept as separate typed futures rather than `Future.wait([...])` since
    // the three repositories return differently-typed `Result<List<...>>`s
    // that don't unify into one list literal's type.
    final offersFuture = ref.read(offersRepositoryProvider).getMyOffers(userId);
    final servicesFuture = ref
        .read(servicesRepositoryProvider)
        .getMyServices(userId);
    final adsFuture = ref.read(adsRepositoryProvider).getMyAds(userId);

    final offersResult = await offersFuture;
    final servicesResult = await servicesFuture;
    final adsResult = await adsFuture;
    if (_disposed) return;

    final offers = offersResult.when(
      success: (v) => v,
      failure: (_) => const <OfferListing>[],
    );
    final services = servicesResult.when(
      success: (v) => v,
      failure: (_) => const <PromooService>[],
    );
    final ads = adsResult.when(
      success: (v) => v,
      failure: (_) => const <AdListing>[],
    );

    final newState = MyListingsState(
      status: MyListingsStatus.success,
      offers: offers,
      services: services,
      ads: ads,
    );
    state = newState.isEmpty
        ? const MyListingsState.empty()
        : newState;
  }

  Future<void> retry() => load();

  Future<bool> deleteOffer(String id) async {
    final current = state;
    state = current.copyWith(
      offers: current.offers.where((o) => o.id != id).toList(),
    );
    final result = await ref.read(offersRepositoryProvider).deleteOffer(id);
    if (_disposed) return result.isSuccess;
    return result.when(
      success: (_) => true,
      failure: (_) {
        state = current;
        return false;
      },
    );
  }

  Future<bool> deleteService(String id) async {
    final current = state;
    state = current.copyWith(
      services: current.services.where((s) => s.id != id).toList(),
    );
    final result = await ref.read(servicesRepositoryProvider).deleteService(id);
    if (_disposed) return result.isSuccess;
    return result.when(
      success: (_) => true,
      failure: (_) {
        state = current;
        return false;
      },
    );
  }

  Future<bool> deleteAd(String id) async {
    final current = state;
    state = current.copyWith(
      ads: current.ads.where((a) => a.id != id).toList(),
    );
    final result = await ref.read(adsRepositoryProvider).deleteAd(id);
    if (_disposed) return result.isSuccess;
    return result.when(
      success: (_) => true,
      failure: (_) {
        state = current;
        return false;
      },
    );
  }
}
