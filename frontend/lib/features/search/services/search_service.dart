import 'dart:convert';

import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/search/models/yoga_category.dart';
import 'package:frontend/features/search/models/yoga_search_result.dart';
import 'package:http/http.dart' as http;

class SearchService {
  static const String _baseUrl = 'https://j12a103.p.ssafy.io:8444';

  static Future<List<YogaCategory>> fetchMainYogaCategories({
    int sampleSize = 3,
  }) async {
    final token = await AuthService().getAccessToken();

    if (token == null) {
      throw Exception('엑세스 토큰이 존재하지 않습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/api/look?sampleSize=$sampleSize'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data as List).map((item) => YogaCategory.fromJson(item)).toList();
    } else {
      throw Exception('요가 데이터를 불러오는 데 실패하였습니다: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchSearchResults({
    String? keyword,
    List<int>? tagIds,
    List<String>? tagNames,
    int page = 0,
    int size = 10,
  }) async {
    final token = await AuthService().getAccessToken();

    final uri = Uri.parse('$_baseUrl/api/look/search').replace(
      queryParameters: {
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (tagIds != null && tagIds.isNotEmpty) 'tagIdList': tagIds.join(','),
        if (tagNames != null && tagNames.isNotEmpty)
          'tagNameList': tagNames.join(','),
        'page': page.toString(),
        'size': size.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return {
        'results':
            (body['content'] as List)
                .map((item) => YogaSearchResult.fromJson(item))
                .toList(),
        'totalPages': body['totalPages'],
      };
    } else {
      throw Exception('검색 실패: ${response.statusCode}');
    }
  }
}
