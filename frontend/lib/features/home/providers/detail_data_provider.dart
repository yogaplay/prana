import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/home_service.dart';
import '../models/home_model.dart';
import 'package:frontend/core/providers/providers.dart'; // apiClientProvider import

final detailDataProvider = FutureProvider.family<PaginatedSequenceResponse, String>((ref, title) async {
  final apiClient = ref.read(apiClientProvider); // ✅ 전역에서 주입된 apiClient 사용
  final homeService = HomeService(apiClient);
  return homeService.fetchDetailItems(title);
});
