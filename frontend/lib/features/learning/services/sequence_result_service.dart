import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/learning/models/sequence_result_response.dart';

class SequenceResultService {
  final ApiClient _apiClient;

  SequenceResultService(this._apiClient);

  Future<SequenceResultResponse> fetchSequenceResult({
    required int userSequenceId,
    required int sequenceId,
  }) async {
    print('API 요청 시작!');
    print('userSequenceId: $userSequenceId');
    print('sequenceId: $sequenceId');
    final response = await _apiClient.get(
      '/yoga/end',
      queryParameters: {
        'userSequenceId': userSequenceId.toString(),
        'sequenceId': sequenceId.toString(),
      },
    );

    print('응답: $response');

    return SequenceResultResponse.fromJson(response);
  }
}
