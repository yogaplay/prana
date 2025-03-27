import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/home_service.dart';
import '../models/home_model.dart';
import 'package:frontend/core/api/api_client.dart';

final detailDataProvider = FutureProvider.family<PaginatedSequenceResponse, String>((ref, title) async {
  final homeService = HomeService(ApiClient());
  return homeService.fetchDetailItems(title);
});