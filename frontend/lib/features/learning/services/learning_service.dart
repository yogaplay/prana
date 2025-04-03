import 'package:frontend/core/api/api_client.dart';

class LearningService {
  final ApiClient _apiClient;

  LearningService(this._apiClient);

  Future startYoga(int sequenceId) async {
    final response = await _apiClient.post(
      '/yoga/start',
      body: {'sequenceId': sequenceId},
    );
  return response['userSequenceId'];
  }
  
}
