import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '');
  
  final localeCode = ui.window.locale.languageCode;
  await initializeDateFormatting(localeCode, null);
  
  String keyHash = await KakaoSdk.origin;
  print('키 해시: $keyHash');

  runApp(ProviderScope(child: App()));
}
