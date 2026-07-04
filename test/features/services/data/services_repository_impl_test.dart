import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/core/config/app_config.dart';
import 'package:promoo_app/core/config/app_environment.dart';
import 'package:promoo_app/core/network/api_exception.dart';
import 'package:promoo_app/features/services/data/datasources/services_data_source.dart';
import 'package:promoo_app/features/services/data/datasources/services_fake_data_source.dart';
import 'package:promoo_app/features/services/data/dto/services_dto.dart';
import 'package:promoo_app/features/services/data/repositories/services_repository_impl.dart';

void main() {
  test('fake services use AED for demo prices', () async {
    final dto = await const ServicesFakeDataSource().fetchServices();
    final services = dto.toDomain(fallbackCurrency: 'AED');

    expect(services, isNotEmpty);
    expect(
      services.map((service) => service.price?.currency),
      everyElement('AED'),
    );
    expect(
      services.map((service) => service.imageUrls),
      everyElement(isNotEmpty),
    );
  });

  test('fake service detail returns requested service', () async {
    final dto = await const ServicesFakeDataSource().fetchServiceById(
      'service-influencer-launch',
    );
    final service = dto.toDomain(
      fallbackId: 'service-influencer-launch',
      fallbackCurrency: 'AED',
    );

    expect(service.id, 'service-influencer-launch');
    expect(service.title, 'Boutique influencer launch package');
    expect(service.provider?.id, 'profile-saffron-social');
    expect(service.price?.currency, 'AED');
  });

  test('uses fake data source when mock fallback is enabled', () async {
    final fakeDataSource = _RecordingDataSource(
      categories: const ServiceCategoriesDto([
        ServiceCategoryDto(id: 'fake-cat', name: 'Fake'),
      ]),
      services: const PromooServicesDto([
        PromooServiceDto(id: 'fake-service', title: 'Fake service', price: 10),
      ]),
    );
    final remoteDataSource = _ThrowingDataSource();
    final repository = ServicesRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
        fallbackCurrency: 'SAR',
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: fakeDataSource,
    );

    final result = await repository.getServices(
      categoryId: 'fake-cat',
      query: 'fake',
    );

    expect(result.isSuccess, isTrue);
    expect(fakeDataSource.lastCategoryId, 'fake-cat');
    expect(fakeDataSource.lastQuery, 'fake');
    result.when(
      success: (services) {
        expect(services.single.id, 'fake-service');
        expect(services.single.price?.label, '10 SAR');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('uses remote data source when mocks are disabled', () async {
    final remoteDataSource = _RecordingDataSource(
      categories: const ServiceCategoriesDto([]),
      services: const PromooServicesDto([
        PromooServiceDto(
          id: 'remote-service',
          title: 'Remote service',
          price: 25,
          currency: 'USD',
        ),
      ]),
    );
    final repository = ServicesRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
        fallbackCurrency: 'SAR',
      ),
      remoteDataSource: remoteDataSource,
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getServices(
      categoryId: 'cat-1',
      query: 'remote',
    );

    expect(remoteDataSource.lastCategoryId, 'cat-1');
    expect(remoteDataSource.lastQuery, 'remote');
    result.when(
      success: (services) => expect(services.single.price?.label, '25 USD'),
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('loads service detail through active data source', () async {
    final fakeDataSource = _RecordingDataSource(
      categories: const ServiceCategoriesDto([]),
      services: const PromooServicesDto([
        PromooServiceDto(
          id: 'service-detail',
          title: 'Detailed service',
          price: 450,
        ),
      ]),
    );
    final repository = ServicesRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: true,
        fallbackCurrency: 'AED',
      ),
      remoteDataSource: _ThrowingDataSource(),
      fakeDataSource: fakeDataSource,
    );

    final result = await repository.getServiceById('service-detail');

    expect(fakeDataSource.lastDetailId, 'service-detail');
    result.when(
      success: (service) {
        expect(service.title, 'Detailed service');
        expect(service.price?.label, '450 AED');
      },
      failure: (failure) => fail('Expected success, got $failure'),
    );
  });

  test('maps API exceptions to failures', () async {
    final repository = ServicesRepositoryImpl(
      config: const AppConfig(
        environment: AppEnvironment.development,
        baseUrl: AppConfig.defaultDevelopmentBaseUrl,
        useMocks: false,
      ),
      remoteDataSource: _ThrowingDataSource(
        const ApiException(
          type: ApiExceptionType.timeout,
          message: 'The request timed out.',
        ),
      ),
      fakeDataSource: _ThrowingDataSource(),
    );

    final result = await repository.getCategories();

    expect(result.isFailure, isTrue);
    result.when(
      success: (categories) => fail('Expected failure, got $categories'),
      failure: (failure) => expect(failure.message, 'The request timed out.'),
    );
  });
}

class _RecordingDataSource implements ServicesDataSource {
  _RecordingDataSource({required this.categories, required this.services});

  final ServiceCategoriesDto categories;
  final PromooServicesDto services;
  String? lastCategoryId;
  String? lastQuery;
  String? lastDetailId;

  @override
  Future<ServiceCategoriesDto> fetchCategories() async {
    return categories;
  }

  @override
  Future<PromooServicesDto> fetchServices({
    String? categoryId,
    String? query,
  }) async {
    lastCategoryId = categoryId;
    lastQuery = query;
    return services;
  }

  @override
  Future<PromooServiceDto> fetchServiceById(String id) async {
    lastDetailId = id;
    return services.services.first;
  }
}

class _ThrowingDataSource implements ServicesDataSource {
  const _ThrowingDataSource([
    this.error = const FormatException('Unexpected data source call.'),
  ]);

  final Object error;

  @override
  Future<ServiceCategoriesDto> fetchCategories() {
    return Future<ServiceCategoriesDto>.error(error);
  }

  @override
  Future<PromooServicesDto> fetchServices({String? categoryId, String? query}) {
    return Future<PromooServicesDto>.error(error);
  }

  @override
  Future<PromooServiceDto> fetchServiceById(String id) {
    return Future<PromooServiceDto>.error(error);
  }
}
