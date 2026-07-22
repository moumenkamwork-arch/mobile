import '../../../../core/utils/result.dart';
import '../entities/report_draft.dart';

abstract interface class ReportsRepository {
  /// `POST /reports` (auth-only). Returns the new report's id on success.
  /// The backend rejects a duplicate open report on the same item with a 400.
  Future<Result<String>> submitReport(ReportDraft draft);
}
