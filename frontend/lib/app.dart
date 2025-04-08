import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/alarm/providers/alarm_provider.dart';
import 'package:frontend/routes.dart';

final splashRemovedProvider = StateProvider<bool>((ref) => false);

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    // Isolate 통신 설정
    final alarmPort = ReceivePort();
    IsolateNameServer.registerPortWithName(alarmPort.sendPort, 'alarm_port');
    alarmPort.listen((message) {
      if (message['type'] == 'alarm_updated') {
        ref.read(alarmProvider.notifier).loadAlarms();
      }
    });

    // 앱 초기화 및 데이터 로딩 후 스플래시 제거
    _initializeAppAndRemoveSplash();
  }

  Future<void> _initializeAppAndRemoveSplash() async {
    try {
      // 앱 초기화
      await initializeApp(ref);

      // 로그인 상태 확인
      final isLoggedIn = await ref.read(authStateProvider.future);

      // 로그인된 경우 홈 데이터 로드
      if (isLoggedIn) {
        try {
          await ref.read(homeDataProvider.future);
        } catch (e) {
          print('홈 데이터 로드 실패: $e');
        }
      }

      // 모든 초기화 완료 후 스플래시 제거
      if (mounted) {
        FlutterNativeSplash.remove();
        ref.read(splashRemovedProvider.notifier).state = true;
      }
    } catch (e) {
      print('앱 초기화 오류: $e');
      // 오류가 발생해도 스플래시는 제거
      if (mounted) {
        FlutterNativeSplash.remove();
        ref.read(splashRemovedProvider.notifier).state = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prana',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true, // ✅ 추가
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // ✅ 중요: 배경색 변화 방지
          scrolledUnderElevation: 0, // ✅ 스크롤 시 그림자 제거
          foregroundColor: Colors.black,
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
