import '../../domain/entities/promoo_service.dart';
import '../dto/services_dto.dart';

abstract interface class ServicesDataSource {
  Future<ServiceCategoriesDto> fetchCategories();

  Future<PromooServicesDto> fetchServices({String? categoryId, String? query});

  Future<PromooServiceDto> fetchServiceById(String id);

  Future<String> createService(ServiceDraft draft);

  Future<void> updateService(String id, ServiceDraft draft);

  Future<void> deleteService(String id);

  Future<PromooServicesDto> fetchServicesByProfile(String profileId);
}
