import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/promoo_service.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_data_source.dart';
import '../datasources/services_fake_data_source.dart';
import '../datasources/services_remote_data_source.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(servicesRemoteDataSourceProvider),
    fakeDataSource: ref.watch(servicesFakeDataSourceProvider),
  );
});

class ServicesRepositoryImpl implements ServicesRepository {
  const ServicesRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final AppConfig config;
  final ServicesDataSource remoteDataSource;
  final ServicesDataSource fakeDataSource;

  ServicesDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    try {
      final dto = await _activeDataSource.fetchCategories();
      return Result.success(dto.toDomain());
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<List<PromooService>>> getServices({
    String? categoryId,
    String? query,
  }) async {
    try {
      final dto = await _activeDataSource.fetchServices(
        categoryId: categoryId,
        query: query,
      );
      return Result.success(
        dto.toDomain(fallbackCurrency: config.fallbackCurrency),
      );
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    try {
      final dto = await _activeDataSource.fetchServiceById(id);
      return Result.success(
        dto.toDomain(fallbackId: id, fallbackCurrency: config.fallbackCurrency),
      );
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
