import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/report_draft.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_data_source.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepositoryImpl(ref.watch(reportsRemoteDataSourceProvider));
});

class ReportsRepositoryImpl implements ReportsRepository {
  const ReportsRepositoryImpl(this._dataSource);

  final ReportsRemoteDataSource _dataSource;

  @override
  Future<Result<String>> submitReport(ReportDraft draft) async {
    try {
      return Result.success(await _dataSource.submitReport(draft));
    } on AppFailure catch (failure) {
      return Result.failure(failure);
    } catch (_) {
      return const Result.failure(AppFailure.unknown());
    }
  }
}
