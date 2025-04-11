import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/services/favorite_service.dart';
import 'package:frontend/features/learning/services/sequence_detail_service.dart';

// 현재 선택된 시퀀스의 상세 정보 저장
final selectedSequenceProvider = StateProvider<SequenceDetailModel?>(
  (ref) => null,
);

final sequenceDetailServiceProvider = Provider<SequenceDetailService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SequenceDetailService(apiClient);
});

final sequenceDetailProvider = FutureProvider.family<SequenceDetailModel, int>((
  ref,
  sequenceId,
) async {
  final sequenceService = ref.read(sequenceDetailServiceProvider);
  return sequenceService.fetchSequenceDetailData(sequenceId);
});

// 즐겨찾기
final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FavoriteService(apiClient);
});
final sequenceFavoriteProvider =
    StateNotifierProvider.family<FavoriteNotifier, AsyncValue<bool>, int>((
      ref,
      sequenceId,
    ) {
      final notifier = FavoriteNotifier(
        ref.read(favoriteServiceProvider),
        sequenceId,
      );

      final sequenceDetail = ref.read(sequenceDetailProvider(sequenceId));
      sequenceDetail.whenData((sequence) {
        notifier.setInitialState(sequence.star);
      });

      ref.listen<AsyncValue<SequenceDetailModel>>(
        sequenceDetailProvider(sequenceId),
        (previous, next) {
          next.whenData((sequence) {
            notifier.setInitialState(sequence.star);
          });
        },
      );

      return notifier;
    });

// 즐겨찾기 상태 관리
class FavoriteNotifier extends StateNotifier<AsyncValue<bool>> {
  final FavoriteService _favoriteService;
  final int sequenceId;

  FavoriteNotifier(this._favoriteService, this.sequenceId)
    : super(const AsyncValue.loading());

  void setInitialState(bool isFavorite) {
    state = AsyncValue.data(isFavorite);
  }

  Future<void> toggleFavorite() async {
    if (state is AsyncData) {
      final currentValue = (state as AsyncData<bool>).value;

      // 낙관적 UI 업데이트
      state = AsyncValue.data(!currentValue);

      try {
        // API 호출로 즐겨찾기 토글
        final newState = await _favoriteService.toggleFavorite(sequenceId);

        // 서버 응답으로 상태 업데이트 (이미 낙관적으로 업데이트된 상태와 다를 경우)
        if (newState != !currentValue) {
          state = AsyncValue.data(newState);
        }
      } catch (e) {
        // 오류 발생 시 원래 상태로 복원
        state = AsyncValue.data(currentValue);
      }
    }
  }
}
