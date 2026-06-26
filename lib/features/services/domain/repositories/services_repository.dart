import '../../../../core/utils/result.dart';
import '../entities/promoo_service.dart';

abstract interface class ServicesRepository {
  Future<Result<List<ServiceCategory>>> getCategories();

  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  });

  Future<Result<PromooService>> getServiceById(String id);
}
