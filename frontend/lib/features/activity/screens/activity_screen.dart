import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/report/providers/weekly_report_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/features/activity/services/activity_service.dart';

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  Set<DateTime> _activeDates = {};

  late final ActivityService _activityService;

  @override
  void initState() {
    super.initState();

    final apiClient = ref.read(apiClientProvider);
    _activityService = ActivityService(apiClient);

    apiClient.getStoredToken().then((token) {
      print(token);
      if (token != null) {
        apiClient.setAuthToken(token);
      }
      _loadEventsForDay(_focusedDay);
      _loadActiveDatesForMonth(_focusedDay); // ✅ 초기 마커 로딩
    });
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    final utcDay = DateTime.utc(day.year, day.month, day.day);
    if (_events.containsKey(utcDay)) return;

    try {
      final events = await _activityService.fetchDailySequence(day);
      setState(() {
        _events[utcDay] = events;
      });
    } catch (e) {
      print("데이터 로딩 실패: $e");
    }
  }

  Future<void> _loadActiveDatesForMonth(DateTime month) async {
    try {
      final activeDates = await _activityService.fetchActiveDatesForMonth(
        month,
      );
      setState(() {
        _activeDates = activeDates;
      });
    } catch (e) {
      print("활동 날짜 로딩 실패: $e");
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final displayDay = _selectedDay ?? _focusedDay;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '활동',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final date = (_selectedDay ?? _focusedDay);
              final formatted =
                  "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
              print(formatted);
              context.pushNamed(
                "weekly_report",
                queryParameters: {'date': formatted},
              );
            },
            child: const Text(
              '주간리포트',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          calendar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${displayDay.month}월 ${displayDay.day}일의 운동',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _getEventsForDay(displayDay).isEmpty
              ? const Center(
                  child: Text(
                    '해당 날짜의 운동 기록이 없습니다.',
                  ) 
              ) 
            :ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  _getEventsForDay(displayDay).map((event) {
                    final title = event['sequence_name'] ?? '제목 없음';
                    final percentRaw = event['percent'];
                    final parsedValue = double.tryParse(
                      (percentRaw == null || percentRaw == 'null') ? '0' : percentRaw
                    ) ?? 0.0;

                    final percentText = '${parsedValue.toInt()}%';
                    final imageUrl = event['image'] ?? '';
                    final isDone = event['result_status'] == 'Y';

                    return InkWell(
                      onTap: () {
                        // if (percentText == '100%') {
                        //   context.push('/sequence/${event['sequeunce_id']}/result/${event['user_sequence_id']}');
                        // } else {
                        //   context.push('/sequence/${event['sequence_id']}');
                        // }
                        context.push('/sequence/${event['sequence_id']}');
                        
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/Uttana_Shishosana.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      isDone ? Icons.check_circle : Icons.more_horiz,
                                      size: 16,
                                      color: isDone ? const Color(0xff7ECECA) : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 제목
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // 진행률 바 + 퍼센트
                                  Row(
                                    children: [
                                      Text(
                                        percentText,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: parsedValue / 100,
                                          backgroundColor: const Color(0xffE8FAF1),
                                          color: const Color(0xff7ECECA),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget calendar() {
    return TableCalendar(
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontFamily: 'Pretendard'),
        weekendStyle: TextStyle(fontFamily: 'Pretendard'),
      ),
      focusedDay: _focusedDay,
      firstDay: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
      locale: 'ko_KR',
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: _getEventsForDay,
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleCentered: true,
        formatButtonVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) async {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        await _loadEventsForDay(selectedDay);
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        _loadActiveDatesForMonth(focusedDay); // ✅ 현재 표시 중인 월 기준으로 마커 갱신
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(fontFamily: 'Pretendard'),
        selectedTextStyle: const TextStyle(
          fontFamily: 'Pretendard',
          color: Colors.white,
        ),
        todayTextStyle: const TextStyle(fontFamily: 'Pretendard'),
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF7ECECA),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: Color(0xFF7ECECA),
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          const daysKor = ['월', '화', '수', '목', '금', '토', '일'];
          return Center(
            child: Text(
              daysKor[day.weekday - 1],
              style: const TextStyle(fontFamily: 'Pretendard'),
            ),
          );
        },
        markerBuilder: (context, day, events) {
          final isMarked = _activeDates.contains(
            DateTime.utc(day.year, day.month, day.day),
          );
          if (isMarked && !isSameDay(day, _selectedDay)) {
            return Positioned(
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF7ECECA),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
