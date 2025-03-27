import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/search/models/yoga_category.dart';
import 'package:frontend/features/search/models/yoga_search_result.dart';

class SearchService {
  static final ApiClient apiClient = ApiClient();

  static Future<List<YogaCategory>> fetchMainYogaCategories({
    int sampleSize = 3,
  }) async {
    final response = await apiClient.get('/look?sampleSize=$sampleSize');
    return (response as List)
        .map((item) => YogaCategory.fromJson(item))
        .toList();
  }

  static Future<Map<String, dynamic>> fetchSearchResults({
    String? keyword,
    List<int>? tagIds,
    List<String>? tagNames,
    int page = 0,
    int size = 10,
  }) async {
    final queryParams = <String, String>{
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (tagIds != null && tagIds.isNotEmpty) 'tagIdList': tagIds.join(','),
      if (tagNames != null && tagNames.isNotEmpty)
        'tagNameList': tagNames.join(','),
      'page': page.toString(),
      'size': size.toString(),
    };

    final queryString = Uri(queryParameters: queryParams).query;
    final response = await apiClient.get('/look/search?$queryString');

    return {
      'results':
          (response['content'] as List)
              .map((item) => YogaSearchResult.fromJson(item))
              .toList(),
      'totalPages': response['totalPages'],
    };
  }
}
