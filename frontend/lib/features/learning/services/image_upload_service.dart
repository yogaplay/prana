import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:http_parser/http_parser.dart';

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ImageUploadService(apiClient);
});

class ImageUploadService {
  final ApiClient apiClient;

  ImageUploadService(this.apiClient);

  Future<String?> uploadImage(Uint8List imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes.toList(),
          filename: 'result_screenshot.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await apiClient.postFormData('/s3', formData);
      return response['url'] as String?;
    } catch (e) {
      print('이미지 업로드 실패: $e');
      return null;
    }
  }
}
