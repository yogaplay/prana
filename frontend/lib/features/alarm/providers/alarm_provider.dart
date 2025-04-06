import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/shared_prefs_provider.dart'; // 추가
import 'package:frontend/features/alarm/models/alarm_model.dart';

final alarmProvider = StateNotifierProvider<AlarmNotifier, List<AlarmItem>>((
  ref,
) {
  return AlarmNotifier(ref);
});

class AlarmNotifier extends StateNotifier<List<AlarmItem>> {
  final Ref ref;

  AlarmNotifier(this.ref) : super([]) {
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final prefs = ref.read(sharedPrefsProvider); // 의존성 주입
    await prefs.reload();
    final storedNotifications = prefs.getString('notifications');

    if (storedNotifications != null) {
      final decodedList = jsonDecode(storedNotifications) as List<dynamic>;
      state =
          decodedList.reversed.map((item) => AlarmItem.fromJson(item)).toList();
    } else {
      state = [];
    }
  }

  Future<void> markAsChecked(int index) async {
    final prefs = ref.read(sharedPrefsProvider); // 의존성 주입
    final newList = List<AlarmItem>.from(state);

    if (!newList[index].isChecked) {
      newList[index] = newList[index].copyWith(isChecked: true);

      await prefs.setString(
        'notifications',
        jsonEncode(newList.reversed.map((e) => e.toJson()).toList()),
      );
      state = newList;
    }
  }

  Future<void> deleteAlarm(int index) async {
    final prefs = ref.read(sharedPrefsProvider); // 의존성 주입
    final newList = List<AlarmItem>.from(state);
    newList.removeAt(index);

    await prefs.setString(
      'notifications',
      jsonEncode(newList.reversed.map((e) => e.toJson()).toList()),
    );
    state = newList;
  }
}
