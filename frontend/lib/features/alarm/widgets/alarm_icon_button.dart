import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/alarm/providers/alarm_provider.dart'; // 새 provider import
import 'package:frontend/features/alarm/screens/alarm_screen.dart';

class AlarmIconButton extends ConsumerWidget {
  const AlarmIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmProvider); // alarmProvider로 변경
    final hasUnchecked = alarms.any((alarm) => !alarm.isChecked);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
          ),
          onPressed: () => _navigateToAlarmScreen(context, ref),
        ),
        if (hasUnchecked)
          Positioned(
            right: 12,
            top: 12,
            child: AnimatedScale(
              scale: hasUnchecked ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToAlarmScreen(BuildContext context, WidgetRef ref) async {
    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(CupertinoPageRoute(builder: (_) => const AlarmScreen()));

    // 화면 복귀 시 알람 상태 강제 갱신
    ref.read(alarmProvider.notifier).loadAlarms();
  }
}
