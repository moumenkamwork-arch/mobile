import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/services_dto.dart';
import 'services_data_source.dart';

final servicesRemoteDataSourceProvider = Provider<ServicesRemoteDataSource>((
  ref,
) {
  return ServicesRemoteDataSource(ref.watch(apiClientProvider));
});

class ServicesRemoteDataSource implements ServicesDataSource {
  const ServicesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ServiceCategoriesDto> fetchCategories() async {
    final response = await _apiClient.get<ServiceCategoriesDto>(
      ApiEndpoints.categories,
      decode: ServiceCategoriesDto.fromJsonFlexible,
    );

    return response.data ?? ServiceCategoriesDto.empty();
  }

  @override
  Future<PromooServicesDto> fetchServices({
    String? categoryId,
    String? query,
  }) async {
    final queryParameters = <String, Object?>{
      if (categoryId != null && categoryId.trim().isNotEmpty)
        'category_id': categoryId,
      if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
    };

    final response = await _apiClient.get<PromooServicesDto>(
      ApiEndpoints.services,
      queryParameters: queryParameters,
      decode: PromooServicesDto.fromJsonFlexible,
    );

    return response.data ?? PromooServicesDto.empty();
  }

  @override
  Future<PromooServiceDto> fetchServiceById(String id) async {
    final response = await _apiClient.get<PromooServiceDto>(
      ApiEndpoints.serviceById(id),
      decode: (data) {
        final maps = PromooServicesDto.fromJsonFlexible(data).services;
        if (maps.isEmpty) {
          throw const FormatException('Expected service detail object.');
        }
        return maps.first;
      },
    );

    final service = response.data;
    if (service == null) {
      throw const FormatException('Expected service detail object.');
    }
    return service;
  }
}
