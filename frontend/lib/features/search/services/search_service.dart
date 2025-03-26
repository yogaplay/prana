import 'dart:convert';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/search/models/yoga_search_result.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SearchService {
  static const String _baseUrl =
      'https://j12a103.p.ssafy.io:8444/api/look/search';

  static Future<List<YogaSearchResult>> fetchSearchResults({
    String? keyword,
    List<int>? tagIds,
    List<String>? tagNames,
    int page = 0,
    int size = 10,
  }) async {
    final token = await AuthService().getAccessToken();

    final uri = Uri.parse(_baseUrl).replace(
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
      final List<dynamic> content = body['content'];
      return content.map((item) => YogaSearchResult.fromJson(item)).toList();
    } else {
      throw Exception('검색 실패: ${response.statusCode}');
    }
  }
}
