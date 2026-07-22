import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/promoo_service.dart';
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

  Map<String, Object?> _body(ServiceDraft draft) {
    return {
      'category_id': draft.categoryId,
      'title': draft.title,
      'description': draft.description,
      'price': draft.price,
      'currency': draft.currency,
      'delivery_days': draft.deliveryDays,
      'media_urls': draft.mediaUrls,
      'tags': draft.tags,
    };
  }

  @override
  Future<String> createService(ServiceDraft draft) async {
    final response = await _apiClient.post<String>(
      ApiEndpoints.services,
      data: _body(draft),
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : const {};
        return (map['id'] as String?) ?? '';
      },
    );
    return response.data ?? '';
  }

  @override
  Future<void> updateService(String id, ServiceDraft draft) async {
    await _apiClient.put<void>(
      ApiEndpoints.serviceById(id),
      data: _body(draft),
      decode: (_) {},
    );
  }

  @override
  Future<void> deleteService(String id) async {
    await _apiClient.delete<void>(
      ApiEndpoints.serviceById(id),
      decode: (_) {},
    );
  }

  @override
  Future<PromooServicesDto> fetchServicesByProfile(String profileId) async {
    final response = await _apiClient.get<PromooServicesDto>(
      ApiEndpoints.servicesByProfile(profileId),
      decode: PromooServicesDto.fromJsonFlexible,
    );
    return response.data ?? PromooServicesDto.empty();
  }
}
