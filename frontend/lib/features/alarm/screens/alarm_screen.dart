import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/alarm/models/alarm_model.dart';
import 'package:frontend/features/alarm/providers/alarm_provider.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends ConsumerWidget {
  const AlarmScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmProvider);
    final alarmNotifier = ref.read(alarmProvider.notifier);

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
            onPressed: () => alarmNotifier.loadAlarms(),
          ),
        ],
      ),
      body:
          alarms.isEmpty
              ? const Center(child: Text('알림이 없습니다'))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: alarms.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return Dismissible(
                    key: ValueKey(alarm.date),
                    direction: DismissDirection.endToStart,
                    background: _buildDeleteBackground(),
                    onDismissed:
                        (direction) => alarmNotifier.deleteAlarm(index),
                    // 삭제 처리
                    child: AlarmCard(
                      alarm: alarm,
                      index: index,
                      onCheck: () => alarmNotifier.markAsChecked(index),
                    ),
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
