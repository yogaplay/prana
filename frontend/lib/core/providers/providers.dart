import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/auth/services/signup_service.dart';
import 'package:frontend/features/home/models/home_model.dart';
import 'package:frontend/features/home/services/home_service.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/services/favorite_service.dart';
import 'package:frontend/features/learning/services/sequence_detail_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://j12a103.p.ssafy.io:8444/api');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final authService = AuthService(apiClient: apiClient);

  apiClient.setAuthService(authService);

  return authService;
});

// 인증 상태 관리
final authStateProvider = FutureProvider<bool>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.isLoggedIn();
});

final signupServiceProvider = Provider<SignupService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SignupService(apiClient: apiClient);
});

final isFirstLoginProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isFirstLogin();
});

final homeServiceProvider = Provider<HomeService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeService(apiClient);
});

final homeDataProvider = FutureProvider<ReportResponse>((ref) async {
  final isLoggedIn = await ref.watch(authStateProvider.future);
  if (!isLoggedIn) {
    throw Exception('로그인이 필요합니다');
  }
  final homeService = ref.read(homeServiceProvider);
  return homeService.fetchHomeData();
});

Future<void> initializeApp(WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.initializeTokens();
}

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

      // 즉시 시퀀스 데이터의 현재 상태를 확인하여 초기 상태 설정
      final sequenceDetail = ref.read(sequenceDetailProvider(sequenceId));
      sequenceDetail.whenData((sequence) {
        notifier.setInitialState(sequence.star);
      });

      // 변경 사항 감지를 위한 리스너 추가
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

// 즐겨찾기 상태 관리를 위한 StateNotifier
class FavoriteNotifier extends StateNotifier<AsyncValue<bool>> {
  final FavoriteService _favoriteService;
  final int sequenceId;

  FavoriteNotifier(this._favoriteService, this.sequenceId)
    : super(const AsyncValue.loading()) {
    // 초기 상태는 SequenceDetailModel에서 가져오므로 별도의 로드 필요 없음
  }

  // 초기 즐겨찾기 상태 설정
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
