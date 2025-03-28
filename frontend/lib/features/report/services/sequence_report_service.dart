import 'package:frontend/core/api/api_client.dart';
import '../models/sequence_report_model.dart'; 

class ReportService {
  final ApiClient _apiClient;
  
  ReportService(this._apiClient);
  
  Future<SequenceReportData> fetchReportData() async {
    try {
      final response = await _apiClient.get('/yoga/end');
      return SequenceReportData.fromJson(response);
    } catch (e) {
      print('홈 데이터 불러오기 실패: $e');
      throw Exception('홈 데이터를 불러오는데 실패했습니다.');
    }
  }
}
