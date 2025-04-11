import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/report/models/weekly_report.dart';
import 'package:frontend/features/report/services/weekly_report_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final weeklyReportServiceProvider = Provider<WeeklyReportService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WeeklyReportService(apiClient: apiClient);
});

final weeklyReportProvider = FutureProvider.family<WeeklyReport, String>((
  ref,
  date,
) async {
  final service = ref.watch(weeklyReportServiceProvider);
  return service.fetchWeeklyReport(date);
});
