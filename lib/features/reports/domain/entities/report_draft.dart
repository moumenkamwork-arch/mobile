/// The kind of thing being reported — mirrors the backend
/// `createReportSchema`'s `reported_type` enum exactly.
enum ReportedType { profile, offer, ad, message, service, story, seat }

extension ReportedTypeWire on ReportedType {
  String get wireValue => switch (this) {
    ReportedType.profile => 'profile',
    ReportedType.offer => 'offer',
    ReportedType.ad => 'ad',
    ReportedType.message => 'message',
    ReportedType.service => 'service',
    ReportedType.story => 'story',
    ReportedType.seat => 'seat',
  };
}

/// A report the user is submitting, mapped 1:1 to `POST /reports`.
class ReportDraft {
  const ReportDraft({
    required this.reportedId,
    required this.reportedType,
    required this.reason,
    this.details,
  });

  final String reportedId;
  final ReportedType reportedType;

  /// Short reason (3–255 chars server-side).
  final String reason;

  /// Optional free-text elaboration (≤1000 chars server-side).
  final String? details;
}
