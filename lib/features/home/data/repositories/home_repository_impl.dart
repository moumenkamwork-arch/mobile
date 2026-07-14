import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';
import '../datasources/home_remote_data_source.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    config: ref.watch(appConfigProvider),
    dataSource: ref.watch(homeRemoteDataSourceProvider),
  );
});

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required this.config, required this.dataSource});

  final AppConfig config;
  final HomeDataSource dataSource;

  @override
  Future<Result<HomeContent>> getHomeContent() async {
    try {
      final dto = await dataSource.fetchHomeContent();
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
  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    if (!request.isValid) {
      return const Result.failure(
        AppFailure.validation(message: 'Home detail is unavailable.'),
      );
    }

    try {
      final dto = await dataSource.fetchHomeContentDetail(request);
      return Result.success(
        dto.toDomain(
          fallbackId: request.id,
          fallbackCurrency: config.fallbackCurrency,
        ),
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
