import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/report_draft.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  return ReportsRemoteDataSource(ref.watch(apiClientProvider));
});

class ReportsRemoteDataSource {
  const ReportsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<String> submitReport(ReportDraft draft) async {
    final body = <String, Object?>{
      'reported_id': draft.reportedId,
      'reported_type': draft.reportedType.wireValue,
      'reason': draft.reason,
      if (draft.details != null && draft.details!.trim().isNotEmpty)
        'details': draft.details!.trim(),
    };

    final response = await _apiClient.post<String>(
      ApiEndpoints.reports,
      data: body,
      decode: (data) {
        final map = data is Map ? Map<String, Object?>.from(data) : const {};
        return (map['id'] as String?) ?? '';
      },
    );
    return response.data ?? '';
  }
}
