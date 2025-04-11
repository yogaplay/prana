import 'package:frontend/all/models/see_all_item.dart';
import 'package:frontend/core/api/api_client.dart';

class SeeAllService {
  final ApiClient _apiClient;

  SeeAllService(this._apiClient);

  Future<List<SeeAllItem>> fetchByTag({required String tagName}) async {
    final response = await _apiClient.post(
      '/look/tag',
      body: {'tagName': tagName},
    );

    final sequences = response['sequences'] as List<dynamic>;

    return sequences.map((json) => SeeAllItem.fromJson(json)).toList();
  }
}
