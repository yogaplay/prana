import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/alarm/models/alarm_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late Future<List<AlarmItem>> _alarmsFuture;

  @override
  void initState() {
    super.initState();
    _alarmsFuture = _loadAlarms();
  }

  Future<List<AlarmItem>> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String? storedNotifications = prefs.getString('notifications');
    if (storedNotifications != null) {
      List<dynamic> decodedList = jsonDecode(storedNotifications);
      return decodedList.reversed
          .map((item) => AlarmItem.fromJson(item))
          .toList();
    }
    return [];
  }

  // 알림 리스트 업데이트 함수
  Future<void> _markNotificationAsChecked(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final storedNotifications = prefs.getString('notifications');

    if (storedNotifications != null) {
      List<dynamic> decodedList = jsonDecode(storedNotifications);
      List<AlarmItem> notifications =
          decodedList.reversed.map((item) => AlarmItem.fromJson(item)).toList();

      // 이미 체크된 알림은 변경하지 않음
      if (!notifications[index].isChecked) {
        notifications[index].isChecked = true; // 무조건 true로 설정
        await prefs.setString(
          'notifications',
          jsonEncode(notifications.map((e) => e.toJson()).toList()),
        );
      }
    }
  }

  void _refreshNotifications() {
    setState(() {
      _alarmsFuture = _loadAlarms(); // Future 새로 호출
    });
  }

  Future<void> _deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String? storedNotifications = prefs.getString('notifications');

    if (storedNotifications != null) {
      List<dynamic> decodedList = jsonDecode(storedNotifications);

      // UI 인덱스를 실제 저장된 리스트 인덱스로 변환 (역순 저장된 데이터 고려)
      int originalIndex = decodedList.length - 1 - index;
      decodedList.removeAt(originalIndex);

      await prefs.setString(
        'notifications',
        jsonEncode(decodedList),
      );
      _refreshNotifications(); // 리스트 새로고침
    }
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
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
          '알림',
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.blackText),
            onPressed: _refreshNotifications, // 수동 새로고침
          ),
        ],
      ),
      body: FutureBuilder<List<AlarmItem>>(
        future: _alarmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('알림을 불러오는 중 오류가 발생했습니다.'));
          }
          final alarms = snapshot.data ?? [];
          if (alarms.isEmpty) {
            return const Center(child: Text('알림이 없습니다'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: alarms.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            // itemBuilder:
            //     (context, index) => AlarmCard(
            //       alarm: alarms[index],
            //       index: index,
            //       onCheck: () async {
            //         await _markNotificationAsChecked(index);
            //         _refreshNotifications(); // 리스트 새로고침
            //       },
            //     ),
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return Dismissible(
                key: ValueKey(alarm.date), // 고유 키 지정
                direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 스와이프
                background: _buildDeleteBackground(), // 삭제 배경 UI
                onDismissed: (direction) => _deleteNotification(index), // 삭제 처리
                child: AlarmCard(
                  alarm: alarm,
                  index: index,
                  onCheck: () async {
                    await _markNotificationAsChecked(index);
                    _refreshNotifications();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  final AlarmItem alarm;
  final int index;
  final VoidCallback onCheck;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.index,
    required this.onCheck,
  });

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal(); // 로컬 시간대로 변환
    final difference = now.difference(date);

    // 10분 이내 알림
    if (difference.inMinutes <= 1 && !difference.isNegative) {
      return '방금';
    }
    // 오늘 알림
    else if (localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day) {
      return DateFormat('HH:mm').format(localDate);
    }
    // 오늘이 아닌 알림
    else {
      return DateFormat('MM월 dd일').format(localDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData =
        alarm.title == '운동 알림'
            ? Icons.notifications_active_rounded
            : Icons.chat_bubble_outline_rounded;

    return GestureDetector(
      onTap:
          alarm.isChecked
              ? null // 체크된 알림은 탭 비활성화
              : onCheck, // 체크 안 된 알림만 탭 가능
      child: Container(
        decoration: BoxDecoration(
          color:
              alarm.isChecked
                  ? AppColors
                      .background // 확인 시 배경색
                  : AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1, // 그림자 확산 정도
              blurRadius: 6, // 그림자 흐림 정도
              offset: Offset(0, 3), // 그림자의 위치 (x, y)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                // 아이콘
                child: Icon(iconData, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 제목
                      alarm.title,
                      style: const TextStyle(
                        color: AppColors.blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // 메시지
                      alarm.message,
                      style: const TextStyle(
                        color: AppColors.graytext,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                // 시간
                _getFormattedDate(alarm.date),
                style: const TextStyle(color: AppColors.graytext, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
