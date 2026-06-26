import '../dto/services_dto.dart';

abstract interface class ServicesDataSource {
  Future<ServiceCategoriesDto> fetchCategories();

  Future<PromooServicesDto> fetchServices({String? categoryId, String? query});

  Future<PromooServiceDto> fetchServiceById(String id);
}
