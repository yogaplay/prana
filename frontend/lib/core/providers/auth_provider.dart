import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/services/auth_service.dart';

// AuthStatus enum 정의
enum AuthStatus { unknown, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  final bool? isFirstLogin; // null일 수 있음을 명시

  const AuthState({
    required this.status,
    this.error,
    this.isFirstLogin, // 기본값 제거
  });

  // 초기 상태 (로딩 중)
  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);

  // 인증됨 상태
  factory AuthState.authenticated({bool? isFirstLogin}) =>
      AuthState(status: AuthStatus.authenticated, isFirstLogin: isFirstLogin);

  // 인증됨 + isFirstLogin 로딩 중
  factory AuthState.authenticatedLoading() =>
      const AuthState(status: AuthStatus.authenticated, isFirstLogin: null);

  // 인증되지 않음 상태
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  // 오류 상태
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, error: message);

  // isFirstLogin이 결정되었는지 확인
  bool get isFirstLoginDetermined => isFirstLogin != null;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  bool _disposed = false; // dispose 상태를 추적하는 플래그

  // getter for mounted state
  @override
  bool get mounted => !_disposed;

  // 초기 상태는 unknown으로 설정
  AuthStateNotifier(this._authService) : super(AuthState.unknown()) {
    // 생성자에서 초기화 메소드 호출
    _initializeAuthState();
  }

  // 인증 상태 초기화
  Future<void> _initializeAuthState() async {
    if (_disposed) return;

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      print('로그인 상태: $isLoggedIn');

      if (_disposed) return;

      if (isLoggedIn) {
        // 먼저 로그인 상태만 설정하고, isFirstLogin은 아직 null로 둠
        state = AuthState.authenticatedLoading();

        // 그 다음 isFirstLogin 값을 가져옴
        final isFirstLogin = await _authService.isFirstLogin();
        print('첫 로그인 상태: $isFirstLogin');

        if (!_disposed) {
          // 이제 isFirstLogin 값도 설정
          state = AuthState.authenticated(isFirstLogin: isFirstLogin);
          print('인증 상태 설정 완료: isFirstLogin=$isFirstLogin');
        }
      } else {
        if (!_disposed) {
          state = AuthState.unauthenticated();
          print('비인증 상태로 설정');
        }
      }
    } catch (e) {
      print('인증 상태 초기화 중 오류: $e');
      if (!_disposed) {
        state = AuthState.unauthenticated();
      }
    }
  }

  // 로그인 메소드
  Future<bool> login({
    required String accessToken,
    required String refreshToken,
    bool isFirstLogin = false,
  }) async {
    if (_disposed) return false; // 초기에 체크

    try {
      await _authService.saveAccessToken(accessToken);
      await _authService.saveRefreshToken(refreshToken);

      if (!_disposed) {
        state = AuthState.authenticated(isFirstLogin: isFirstLogin);
      }
      return true;
    } catch (e) {
      print('로그인 중 오류: $e');
      return false;
    }
  }

  // 로그아웃 메소드
  Future<void> logout() async {
    if (_disposed) {
      print('StateNotifier가 이미 dispose되었습니다.');
      return;
    }

    try {
      print('로그아웃 시작');
      await _authService.logout();

      if (!_disposed) {
        print('로그아웃 완료: 상태를 unauthenticated로 변경');
        state = AuthState.unauthenticated();
      } else {
        print('로그아웃 처리 중 StateNotifier가 dispose되었습니다.');
      }
    } catch (e) {
      print('로그아웃 중 오류: $e');
      if (!_disposed) {
        state = AuthState.unauthenticated();
      } else {
        print('로그아웃 중 오류(dispose 상태): $e');
      }
    }
  }
  // AuthStateNotifier 클래스에 다음 메서드를 추가합니다

  // isFirstLogin 상태를 업데이트하는 메서드
  Future<void> updateFirstLoginStatus(bool isFirstLogin) async {
    if (_disposed) return;

    try {
      // 로컬 스토리지에 isFirstLogin 상태 저장 (AuthService에 해당 메서드 구현 필요)
      await _authService.setFirstLoginStatus(isFirstLogin);

      if (!_disposed) {
        // 상태 업데이트
        state = AuthState.authenticated(isFirstLogin: isFirstLogin);
        print('isFirstLogin 상태 업데이트: $isFirstLogin');
      }
    } catch (e) {
      print('isFirstLogin 상태 업데이트 중 오류: $e');
    }
  }

  // 리프레시 토큰 검증 및 재발급 처리
  Future<bool> refreshTokens() async {
    if (_disposed) return false;

    try {
      await _authService.refreshToken();

      if (_disposed) return false;

      // 토큰 재발급 성공 시
      state = AuthState.authenticated();
      return true;
    } catch (e) {
      print('토큰 갱신 중 오류: $e');

      if (!_disposed) {
        // 토큰 재발급 실패 시 (리프레시 토큰 없음 등)
        state = AuthState.unauthenticated();
      }
      return false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
