import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/alarm/models/alarm_model.dart';
import 'package:frontend/features/alarm/screens/alarm_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmIconButton extends StatefulWidget {
  const AlarmIconButton({super.key});

  @override
  State<AlarmIconButton> createState() => _AlarmIconButtonState();
}

class _AlarmIconButtonState extends State<AlarmIconButton> {
  bool hasUncheckedAlarms = false;

  @override
  void initState() {
    super.initState();
    _checkUnreadAlarms();
  }

  Future<void> _checkUnreadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final storedNotifications = prefs.getString('notifications');

    if (storedNotifications != null) {
      List<dynamic> decodedList = jsonDecode(storedNotifications);
      List<AlarmItem> notifications =
          decodedList.map((item) => AlarmItem.fromJson(item)).toList();

      // 하나라도 isChecked == false이면 빨간 점 표시
      setState(() {
        hasUncheckedAlarms = notifications.any((alarm) => !alarm.isChecked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const AlarmScreen()),
            );
            _checkUnreadAlarms(); // 알람 화면에서 돌아왔을 때 다시 확인
          },
        ),
        if (hasUncheckedAlarms)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
