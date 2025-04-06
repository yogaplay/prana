import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/profile_providers.dart';
import 'package:frontend/features/alarm/services/alarm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool weeklyReportEnabled = false; // 주간 리포트 설정
  bool dailyExerciseEnabled = false; // 매일 운동 알림 설정
  TimeOfDay weeklyReportTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  ); // 주간 리포트 시간 9:00 AM (고정)
  TimeOfDay selectedTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  ); // 운동 알림 시간 9:00 AM (변동)
  List<bool> selectedDays = [
    // 운동 알림 요일 (변동)
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ]; // 월, 화, 수, 목, 금, 토, 일

  // 운동 알림 시간
  void _showTimePicker() {
    TimeOfDay initialTime = selectedTime;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 280,
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                      onDateTimeChanged: (DateTime newDateTime) {
                        initialTime = TimeOfDay(
                          hour: newDateTime.hour,
                          minute: newDateTime.minute,
                        );
                      },
                      use24hFormat: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(initialTime),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '저장하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedTime = result;
          _updateDailyNotifications(); // 알림 설정/취소 실행
          _saveNotificationSettings(); // ✅ 설정 변경 후 저장
        });
      }
    });
  }

  // 운동 알림 시간 포맷
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // 주간 리포트 알림 설정하기
  void _updateWeekNotifications() async {
    bool granted = await requestNotificationPermission();
    if (!granted) {
      setState(() {
        weeklyReportEnabled = false;
        dailyExerciseEnabled = false;
      });
      _saveNotificationSettings();
      return;
    }
    if (weeklyReportEnabled) {
      // 오전 9시 고정
      const fixedTime = TimeOfDay(hour: 9, minute: 0);
      // DateTime 에서 월요일 = 1, 일요일 = 7
      scheduleWeeklyNotification(200, fixedTime.hour, fixedTime.minute);
    } else {
      cancelNotifications(200, "weekly_report");
    }
  }

  // 운동 알림 설정하기
  void _updateDailyNotifications() async {
    bool granted = await requestNotificationPermission();
    if (!granted) {
      setState(() {
        weeklyReportEnabled = false;
        dailyExerciseEnabled = false;
      });
      _saveNotificationSettings();
      return;
    }
    if (dailyExerciseEnabled) {
      List<int> selectedWeekdays = [];
      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) {
          selectedWeekdays.add(i + 1); // DateTime 에서 월요일 = 1, 일요일 = 7
        }
      }
      scheduleDailyNotification(
        100,
        selectedTime.hour,
        selectedTime.minute,
        selectedWeekdays,
      );
    } else {
      cancelNotifications(100, "daily_report");
    }
  }

  // 알림 설정 저장
  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weeklyReportEnabled', weeklyReportEnabled);
    await prefs.setBool('dailyExerciseEnabled', dailyExerciseEnabled);
    await prefs.setInt('selectedHour', selectedTime.hour);
    await prefs.setInt('selectedMinute', selectedTime.minute);
    await prefs.setStringList(
      'selectedDays',
      selectedDays.map((e) => e.toString()).toList(),
    );
  }

  // 알림 설정 불러오기
  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      weeklyReportEnabled = prefs.getBool('weeklyReportEnabled') ?? false;
      dailyExerciseEnabled = prefs.getBool('dailyExerciseEnabled') ?? false;
      int hour = prefs.getInt('selectedHour') ?? 9;
      int minute = prefs.getInt('selectedMinute') ?? 0;
      selectedTime = TimeOfDay(hour: hour, minute: minute);

      List<String>? savedDays = prefs.getStringList('selectedDays');
      if (savedDays != null) {
        selectedDays = savedDays.map((e) => e == 'true').toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
    _loadNotificationSettings();
    initTimezone();
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackText,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '알림 설정',
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.boxWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 주간 리포트 받기
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '주간 리포트 받기',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoSwitch(
                          value: weeklyReportEnabled,
                          onChanged: (value) {
                            setState(() {
                              weeklyReportEnabled = value;
                              _saveNotificationSettings(); // ✅ 설정 변경 후 저장
                              _updateWeekNotifications(); // 토글이 바뀌면 알림 설정/취소 실행
                            });
                          },
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.lightGray,
                  ),
                  // 매일 운동 알림 받기
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '매일 운동 알림 받기',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoSwitch(
                          value: dailyExerciseEnabled,
                          onChanged: (value) {
                            setState(() {
                              dailyExerciseEnabled = value;
                              _saveNotificationSettings(); // ✅ 설정 변경 후 저장
                              _updateDailyNotifications(); // 토글이 바뀌면 알림 설정/취소 실행
                            });
                          },
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),

                  // 알림 시각 및 요일 선택 (매일 운동 알림이 활성화된 경우에만 표시)
                  if (dailyExerciseEnabled) ...[
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGray,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '알림 시각',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.blackText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _showTimePicker,
                                child: Text(
                                  _formatTimeOfDay(selectedTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blackText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _showTimePicker,
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColors.graytext,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDayButton('월', 0),
                          _buildDayButton('화', 1),
                          _buildDayButton('수', 2),
                          _buildDayButton('목', 3),
                          _buildDayButton('금', 4),
                          _buildDayButton('토', 5),
                          _buildDayButton('일', 6),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(String day, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDays[index] = !selectedDays[index];
          _saveNotificationSettings(); // ✅ 설정 변경 후 저장
          _updateDailyNotifications(); // 요일 선택 변경 시 알림 갱신
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selectedDays[index] ? AppColors.primary : AppColors.lightGray,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: selectedDays[index] ? Colors.white : AppColors.graytext,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
