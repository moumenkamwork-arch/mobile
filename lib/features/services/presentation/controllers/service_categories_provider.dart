import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/services_repository_impl.dart';
import '../../domain/entities/promoo_service.dart';

/// The real `categories` reference list from `GET /categories`, shared by
/// every surface that needs a category picker (Services filter, Add Offer,
/// Add Service). Loading this instead of a hardcoded enum is what lets the
/// create forms send a genuine `category_id` UUID the backend accepts.
/// Kept an autoDispose FutureProvider so it refetches when a picker reopens
/// (categories are reference data — cheap, rarely change, fine to refetch).
final serviceCategoriesProvider = FutureProvider.autoDispose<List<ServiceCategory>>(
  (ref) async {
    final result = await ref.watch(servicesRepositoryProvider).getCategories();
    return switch (result) {
      Success(data: final categories) => categories,
      Failure(failure: final failure) => throw failure,
    };
  },
);
