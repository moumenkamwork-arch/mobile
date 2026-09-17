import '../../../../core/utils/result.dart';
import '../entities/promoo_service.dart';

abstract interface class ServicesRepository {
  Future<Result<List<ServiceCategory>>> getCategories();

  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  });

  Future<Result<PromooService>> getServiceById(String id);

  /// `POST /services` (role-gated to service_provider/company). Returns the
  /// new service's id on success.
  Future<Result<String>> createService(ServiceDraft draft);

  /// `PUT /services/:id` (ownership-checked server-side).
  Future<Result<void>> updateService(String id, ServiceDraft draft);

  /// `DELETE /services/:id` (ownership-checked server-side).
  Future<Result<void>> deleteService(String id);

  /// `GET /services/profile/:id` — every status when the caller is the
  /// owner, active-only otherwise.
  Future<Result<List<PromooService>>> getMyServices(String profileId);
}
