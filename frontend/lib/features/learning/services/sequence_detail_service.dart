import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';

class SequenceDetailService {
  final ApiClient _apiClient;

  SequenceDetailService(this._apiClient);

  Future<SequenceDetailModel> fetchSequenceDetailData(int sequenceId) async {
    try {
      final response = await _apiClient.post(
        '/yoga/sequence',
        body: {'sequenceId': sequenceId},
      );
      print(response);
      return SequenceDetailModel.fromJson(response);
    } catch (e, stackTrace) {

      print('시퀀스 상세 정보 페치 오류: $e');
      print('오류 발생 위치: $stackTrace');
      rethrow;
    }
  }
  
}


