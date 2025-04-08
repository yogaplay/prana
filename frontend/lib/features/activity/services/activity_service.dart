import 'package:frontend/core/api/api_client.dart';

class ActivityService {
  final ApiClient apiClient;

  ActivityService(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchDailySequence(DateTime date) async {
    final String formattedDate = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final response = await apiClient.get('/calendar/daily-sequence/$formattedDate');

    // 응답이 List일 경우 처리 (Map 형태로 래핑되어 올 수도 있음)
    final List<dynamic> data = response['data'] ?? [];
    return data.map((item) => {
      'sequence_id': item['sequenceId'],
      'user_sequence_id' : item['userSequenceId'],
      'sequence_name': item['sequenceName'],
      'result_status': item['resultStatus'],
      'percent': item['percent'].toString(),
      'image': item['image']
    }).toList();
  }
  
  Future<Set<DateTime>> fetchActiveDatesForMonth(DateTime date) async {
    final String formattedMonth = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}";
    
    print(formattedMonth);
    final response = await apiClient.get('/calendar/active/$formattedMonth');

      // ✅ 응답 전체 로그 찍기
    print('📥 activeDates 응답: $response');
    final List<dynamic> data = response['activeDates'] ?? [];

    return data.map<DateTime>((dateStr) {
      final date = DateTime.parse(dateStr);
      return DateTime.utc(date.year, date.month, date.day);
    }).toSet();
  }
}
