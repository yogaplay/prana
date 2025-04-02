import 'package:frontend/core/api/api_client.dart';
import '../models/sequence_event.dart';

class ActivityService {
  final ApiClient _apiClient;

  ActivityService(this._apiClient);

  /// 활동이 있는 날짜 (예: ["2025-04-01", "2025-04-02"])
  Future<List<DateTime>> fetchActiveDays(String yearMonth) async {
    try {
      print('[📤 REQUEST] /calendar/active/$yearMonth');
      final res = await _apiClient.get('/calendar/active/$yearMonth');
      print('[📥 RESPONSE] /calendar/active/$yearMonth → $res');

      // 예시: 날짜 리스트가 있다고 가정하는 경우
      if (res.containsKey('data')) {
        final List<String> dateStrings = List<String>.from(res['data']);
        return dateStrings.map((e) => DateTime.parse(e)).toList();
      }

      return []; // data 없으면 빈 리스트
    } catch (e) {
      print('[❌ ERROR] fetchActiveDays: $e');
      return [];
    }
  }

  /// 하루의 시퀀스 리스트
  Future<List<SequenceEvent>> fetchDailySequences(String yyyyMMdd) async {
    try {
      print('[📤 REQUEST] /calendar/daily-sequence/$yyyyMMdd');
      final res = await _apiClient.get('/calendar/daily-sequence/$yyyyMMdd');
      print('[📥 RESPONSE] /calendar/daily-sequence/$yyyyMMdd → $res');

      final List<dynamic> data = res['data'];
      return data.map((json) => SequenceEvent.fromJson(json)).toList();
    } catch (e) {
      print('[❌ ERROR] fetchDailySequences: $e');
      return [];
    }
  }
}
