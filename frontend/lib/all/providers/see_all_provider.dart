import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/all/models/see_all_item.dart';
import 'package:frontend/all/services/see_all_service.dart';
import 'package:frontend/core/providers/providers.dart';

final seeAllServiceProvider = Provider<SeeAllService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SeeAllService(apiClient);
});

final seeAllItemsProvider = FutureProvider.family<List<SeeAllItem>, String>((
  ref,
  tagName,
) {
  final service = ref.read(seeAllServiceProvider);
  return service.fetchByTag(tagName: tagName);
});
