import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/services_repository_impl.dart';
import '../../domain/entities/promoo_service.dart';

/// The real `categories` reference list from `GET /categories`, shared by
/// every surface that needs a category picker (Services filter, Add Offer,
/// Add Service). Loading this instead of a hardcoded enum is what lets the
/// create forms send a genuine `category_id` UUID the backend accepts.
/// Kept a plain FutureProvider (cached permanently for the session) since
/// categories are static reference data (cheap, admin-only). Pull-to-refresh
/// on Services tab calls `ref.invalidate(serviceCategoriesProvider)` if fresh.
final serviceCategoriesProvider = FutureProvider<List<ServiceCategory>>(
  (ref) async {
    final result = await ref.watch(servicesRepositoryProvider).getCategories();
    return switch (result) {
      Success(data: final categories) => categories,
      Failure(failure: final failure) => throw failure,
    };
  },
);
