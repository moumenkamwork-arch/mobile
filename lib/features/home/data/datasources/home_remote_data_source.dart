import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/home_content.dart';
import '../dto/home_content_dto.dart';
import 'home_data_source.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource(ref.watch(apiClientProvider));
});

class HomeRemoteDataSource implements HomeDataSource {
  const HomeRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<HomeContentDto> fetchHomeContent() async {
    final response = await _apiClient.get<HomeContentDto>(
      ApiEndpoints.home,
      decode: HomeContentDto.fromJsonFlexible,
    );

    return response.data ?? HomeContentDto.empty();
  }

  @override
  Future<HomeContentDetailDto> fetchHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    return switch (request.type) {
      HomeContentDetailType.offer => _fetchOfferDetail(request.id),
      HomeContentDetailType.ad => _fetchActiveAdDetail(request.id),
      HomeContentDetailType.unknown => throw const AppFailure.validation(
        message: 'Home detail is unavailable.',
      ),
    };
  }

  Future<HomeContentDetailDto> _fetchOfferDetail(String id) async {
    final response = await _apiClient.get<HomeContentDetailDto>(
      ApiEndpoints.offerById(id),
      decode: (data) => HomeContentDetailDto.fromJsonFlexible(
        data,
        fallbackType: HomeContentDetailType.offer,
      ),
    );

    return response.data ??
        (throw const AppFailure.notFound(message: 'Offer not found.'));
  }

  Future<HomeContentDetailDto> _fetchActiveAdDetail(String id) async {
    final response = await _apiClient.get<List<HomeContentDetailDto>>(
      ApiEndpoints.activeAds,
      decode: (data) => HomeContentDetailDto.listFromJsonFlexible(
        data,
        fallbackType: HomeContentDetailType.ad,
      ),
    );

    for (final detail in response.data ?? const <HomeContentDetailDto>[]) {
      if (detail.id == id) {
        return detail;
      }
    }

    throw const AppFailure.notFound(message: 'Promotion not found.');
  }
}
