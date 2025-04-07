import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/services/auth_service.dart';

// AuthStatus enum 정의
enum AuthStatus { unknown, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  final bool isFirstLogin;

  const AuthState({
    required this.status,
    this.error,
    this.isFirstLogin = false,
  });

  // 초기 상태 (로딩 중)
  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);

  // 인증됨 상태
  factory AuthState.authenticated({bool isFirstLogin = false}) =>
      AuthState(status: AuthStatus.authenticated, isFirstLogin: isFirstLogin);

  // 인증되지 않음 상태
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  // 오류 상태
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, error: message);
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  // 초기 상태는 unknown으로 설정
  AuthStateNotifier(this._authService) : super(AuthState.unknown()) {
    // 생성자에서 초기화 메소드 호출
    _initializeAuthState();
  }

  // 인증 상태 초기화
  Future<void> _initializeAuthState() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        final isFirstLogin = await _authService.isFirstLogin();
        state = AuthState.authenticated(isFirstLogin: isFirstLogin);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      print('인증 상태 초기화 중 오류: $e');
      state = AuthState.unauthenticated();
    }
  }

  // 로그인 메소드
  Future<bool> login({
    required String accessToken,
    required String refreshToken,
    bool isFirstLogin = false,
  }) async {
    try {
      await _authService.saveAccessToken(accessToken);
      await _authService.saveRefreshToken(refreshToken);
      state = AuthState.authenticated(isFirstLogin: isFirstLogin);
      return true;
    } catch (e) {
      print('로그인 중 오류: $e');
      return false;
    }
  }

  // 로그아웃 메소드
  Future<void> logout() async {
    try {
      print('로그아웃 시작');
      if (!mounted) {
        print('StateNotifier가 이미 dispose되었습니다.');
        return;
      }

      await _authService.logout();

      if (mounted) {
        // 다시 한번 확인
        print('로그아웃 완료: 상태를 unauthenticated로 변경');
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      if (mounted) {
        print('로그아웃 중 오류: $e');
        state = AuthState.unauthenticated();
      } else {
        print('로그아웃 중 오류(dispose 상태): $e');
      }
    }
  }

  // 리프레시 토큰 검증 및 재발급 처리
  Future<bool> refreshTokens() async {
    try {
      await _authService.refreshToken();
      // 토큰 재발급 성공 시
      state = AuthState.authenticated();
      return true;
    } catch (e) {
      print('토큰 갱신 중 오류: $e');
      // 토큰 재발급 실패 시 (리프레시 토큰 없음 등)
      state = AuthState.unauthenticated();
      return false;
    }
  }
}
