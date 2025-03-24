import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  await initializeDateFormatting('ko_KR', null);
  runApp(const App());
}
