import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/activity/services/activity_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  Set<DateTime> _activeDates = {};

  late final ActivityService _activityService;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _activityService = ActivityService(_apiClient);

    _apiClient.getStoredToken().then((token) {
      if (token != null) {
        _apiClient.setAuthToken(token);
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
      final activeDates = await _activityService.fetchActiveDatesForMonth(month);
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
        title: const Text('활동', style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('주간리포트', style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
          )
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
              style: const TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _getEventsForDay(displayDay).map((event) {
                final title = event['sequence_name'] ?? '제목 없음';
                final percentText = '${event['percent'] ?? '0'}%';
                final parsedValue = double.tryParse(event['percent'] ?? '0') ?? 0.0;
                final imageUrl = event['image'] ?? '';
                final isDone = event['result_status'] == 'Y';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/Uttana_Shishosana.png',
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        isDone ? Icons.check_circle : Icons.more_horiz,
                        size: 16,
                        color: isDone ? const Color(0xFF7ECECA) : Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: parsedValue / 100,
                              backgroundColor: const Color(0xffE8FAF1),
                              color: const Color(0xff7ECECA),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(percentText, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
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
        titleTextStyle: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold),
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
        selectedTextStyle: const TextStyle(fontFamily: 'Pretendard', color: Colors.white),
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
          return Center(child: Text(daysKor[day.weekday - 1], style: const TextStyle(fontFamily: 'Pretendard')));
        },
        markerBuilder: (context, day, events) {
          final isMarked = _activeDates.contains(DateTime.utc(day.year, day.month, day.day));
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
