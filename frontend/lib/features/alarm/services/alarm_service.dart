import 'dart:convert';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/features/alarm/models/alarm_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

// 저장된 알림 불러오기
Future<List<AlarmItem>> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final String? notificationsJson = prefs.getString('notifications');

  if (notificationsJson == null) return [];

  List<dynamic> jsonList = jsonDecode(notificationsJson);
  return jsonList.map((json) => AlarmItem.fromJson(json)).toList();
}

// 알림 권한 요청
Future<bool> requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();

  // 권한이 거절된 경우 앱 설정 화면으로 유도
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }

  return status.isGranted;
}

// 알림 시간 타임존 설정
void initTimezone() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
}

// 안드로이드 알림 초기화 설정 변수
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 알림 취소
void cancelNotifications(int notificationId, String uniqueName) async {
  if (uniqueName == 'daily_report') {
    await Workmanager().cancelByUniqueName('daily_report_1');
    await Workmanager().cancelByUniqueName('daily_report_2');
    await Workmanager().cancelByUniqueName('daily_report_3');
    await Workmanager().cancelByUniqueName('daily_report_4');
    await Workmanager().cancelByUniqueName('daily_report_5');
    await Workmanager().cancelByUniqueName('daily_report_6');
    await Workmanager().cancelByUniqueName('daily_report_7');
  } else {
    await Workmanager().cancelByUniqueName(uniqueName);
  }
  // await Workmanager().cancelAll();
  await flutterLocalNotificationsPlugin.cancel(notificationId);
}

// 알림 초기 설정
void initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(task);
    await _saveNotificationAutomatically(inputData);
    return Future.value(true);
  });
}

Future<void> _saveNotificationAutomatically(Map<String, dynamic>? data) async {
  if (data == null) return;

  final notification = AlarmItem(
    title: data['title'] ?? '알림',
    message: data['message'] ?? '새 알림이 도착했습니다',
    date: DateTime.parse(data['date']),
    isChecked: false,
  );

  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString('notifications');
  List<AlarmItem> notifications =
      stored != null
          ? (jsonDecode(stored) as List)
              .map((e) => AlarmItem.fromJson(e))
              .toList()
          : [];

  if (notifications.length >= 20) notifications.removeAt(0);
  notifications.add(notification);

  // 저장 후 즉시 reload() 호출
  await prefs.setString('notifications', jsonEncode(notifications));
  // 포그라운드에 강제 업데이트 신호 전송
  try {
    final port = IsolateNameServer.lookupPortByName('alarm_port');
    port?.send({'type': 'alarm_updated'});
  } catch (_) {}
}

// 알림 보내기
void scheduleWeeklyNotification(
  int notificationId,
  int hour,
  int minute,
) async {
  int day = 1; // 월요일 고정
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduleDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  // 사용자가 선택한 요일로 이동
  while (scheduleDate.weekday != day) {
    scheduleDate = scheduleDate.add(Duration(days: 1));
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'weekly_reminder_channel',
    'Weekly Reminder',
    channelDescription: '매주 월요일에 알림을 보냅니다.',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await Workmanager().registerPeriodicTask(
    "weekly_report",
    "save_weekly_notification",
    frequency: const Duration(hours: 24 * 7),
    flexInterval: const Duration(hours: 24 * 7),
    initialDelay: _calculateInitialDelay(scheduleDate),
    inputData: {
      'title': getMonthWeekText(scheduleDate),
      'message': '주간 리포트를 확인해보세요.',
      'date': scheduleDate.toIso8601String(),
    },
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId + day, // 요일마다 ID 다르게 설정
    getMonthWeekText(scheduleDate), // 제목
    '주간 리포트를 확인해보세요.', // 내용
    scheduleDate,
    details,
    payload: getMonthWeekText(scheduleDate),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

// 알림 보내기
void scheduleDailyNotification(
  int notificationId,
  int hour,
  int minute,
  List<int> days,
) async {
  for (int day in days) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 사용자가 선택한 요일로 이동
    while (scheduleDate.weekday != day) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          channelDescription: '선택한 요일에 알림을 보냅니다.',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    var calculateInitialDelay = _calculateInitialDelay(scheduleDate);
    print('최초지연시간: ${calculateInitialDelay}');
    print('daily_report_$day');
    await Workmanager().registerPeriodicTask(
      'daily_report_$day', // 고유한 태스크 ID
      'save_daily_notification_$day', // 태스크 이름
      frequency: const Duration(hours: 24 * 7),
      // 1주 간격
      flexInterval: const Duration(hours: 24 * 7),
      // 1주 간격
      initialDelay: calculateInitialDelay,
      // 최초 실행 지연 시간
      inputData: {
        // 저장할 데이터
        'title': '운동 알림',
        'message': '오늘의 운동을 시작해보세요.',
        'date': scheduleDate.toIso8601String(),
      },
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId + day, // 요일마다 ID 다르게 설정
      '운동 알림', // 제목
      '오늘의 운동을 시작해보세요.', // 내용
      scheduleDate,
      details,
      payload: '운동 알림',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
}

// 최초 실행 지연 시간 계산
Duration _calculateInitialDelay(tz.TZDateTime scheduleDate) {
  final now = tz.TZDateTime.now(tz.local);

  // 과거 시간일 경우 같은 요일, 같은 시간의 다음 주로 변경
  if (scheduleDate.isBefore(now)) {
    scheduleDate = scheduleDate.add(const Duration(days: 7));
  }
  return scheduleDate.difference(now);
}

// 몇 월 몇 주차
String getMonthWeekText(tz.TZDateTime date) {
  int month = int.parse(DateFormat('M').format(date));
  int firstDayOfMonth =
      tz.TZDateTime(date.location, date.year, date.month, 1).weekday;

  // 현재 날짜에서 첫 주 고려하여 주차 계산
  int weekOfMonth = ((date.day + firstDayOfMonth - 1) / 7).ceil();

  return '$month월 ${weekOfMonth}주차 리포트 도착';
}
