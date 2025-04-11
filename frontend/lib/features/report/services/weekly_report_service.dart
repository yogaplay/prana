import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/report/models/weekly_report.dart';

class WeeklyReportService {
  final ApiClient apiClient;

  WeeklyReportService({required this.apiClient});

  Future<WeeklyReport> fetchWeeklyReport(String date) async {
    final response = await apiClient.get('/calendar/weekly-report/$date');
    return WeeklyReport.fromJson(response);
  }
}
