import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/seat.dart';
import '../../domain/repositories/seats_repository.dart';
import '../datasources/seats_data_source.dart';
import '../datasources/seats_fake_data_source.dart';
import '../datasources/seats_remote_data_source.dart';

final seatsRepositoryProvider = Provider<SeatsRepository>((ref) {
  return SeatsRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(seatsRemoteDataSourceProvider),
    fakeDataSource: ref.watch(seatsFakeDataSourceProvider),
  );
});

class SeatsRepositoryImpl implements SeatsRepository {
  const SeatsRepositoryImpl({
    required this.config,
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final AppConfig config;
  final SeatsDataSource remoteDataSource;
  final SeatsDataSource fakeDataSource;

  SeatsDataSource get _activeDataSource {
    return config.useMocks ? fakeDataSource : remoteDataSource;
  }

  @override
  Future<Result<List<Seat>>> getSeats({SeatTier? tier}) async {
    try {
      final dto = await _activeDataSource.fetchSeats(tier: tier);
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
  Future<Result<List<Seat>>> getMySeats() async {
    try {
      final dto = await _activeDataSource.fetchMySeats();
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
  Future<Result<SeatBookingResult>> bookSeat(String seatId) async {
    try {
      final dto = await _activeDataSource.bookSeat(seatId);
      return Result.success(dto.toDomain());
    } on ApiException catch (error) {
      return Result.failure(AppFailure.fromException(error));
    } on FormatException catch (error) {
      return Result.failure(AppFailure.parsing(message: error.message));
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
