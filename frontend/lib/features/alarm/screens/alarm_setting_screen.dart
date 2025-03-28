import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool weeklyReportEnabled = true;
  bool dailyExerciseEnabled = false;
  TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM
  List<bool> selectedDays = [
    false,
    false,
    true,
    false,
    false,
    false,
    false,
  ]; // 월, 화, 수, 목, 금, 토, 일

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
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
              setState(() {
                selectedTime = TimeOfDay(
                  hour: newDateTime.hour,
                  minute: newDateTime.minute,
                );
              });
            },
            use24hFormat: false,
          ),
        );
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
