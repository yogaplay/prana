import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/alarm/providers/alarm_provider.dart';
import 'package:frontend/routes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeApp(ref);
    });

    FlutterNativeSplash.remove();

    // Isolate 통신 설정
    final alarmPort = ReceivePort();
    IsolateNameServer.registerPortWithName(alarmPort.sendPort, 'alarm_port');
    alarmPort.listen((message) {
      if (message['type'] == 'alarm_updated') {
        ref.read(alarmProvider.notifier).loadAlarms();
      }
    });

    return MaterialApp.router(
      title: 'Prana',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
