import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/promoo_service.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_data_source.dart';
import '../datasources/services_remote_data_source.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepositoryImpl(
    config: ref.watch(appConfigProvider),
    dataSource: ref.watch(servicesRemoteDataSourceProvider),
  );
});

class ServicesRepositoryImpl implements ServicesRepository {
  const ServicesRepositoryImpl({
    required this.config,
    required this.dataSource,
  });

  final AppConfig config;
  final ServicesDataSource dataSource;

  @override
  Future<Result<List<ServiceCategory>>> getCategories() async {
    try {
      final dto = await dataSource.fetchCategories();
      return Result.success(dto.toDomain());
    } on AppFailure catch (failure) {
      return Result.failure(failure);
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
      final dto = await dataSource.fetchServices(
        categoryId: categoryId,
        query: query,
      );
      return Result.success(
        dto.toDomain(fallbackCurrency: config.fallbackCurrency),
      );
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }

  @override
  Future<Result<PromooService>> getServiceById(String id) async {
    try {
      final dto = await dataSource.fetchServiceById(id);
      return Result.success(
        dto.toDomain(fallbackId: id, fallbackCurrency: config.fallbackCurrency),
      );
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
