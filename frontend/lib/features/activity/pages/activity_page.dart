import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.utc(2025, 3, 24): [
      {
        "sequence_id": 1,
        "sequence_name": "앉아서 하는 요가",
        "result_status": "N",
        "percent": "21",
        "image": 'assets/images/Uttana_shishosana.png'
      },
      {
        "sequence_id": 2,
        "sequence_name": "엉덩이를 위한 요가 시퀀스",
        "result_status": "Y",
        "percent": "100",
        "image": 'assets/images/Uttana_shishosana.png'
      },
    ],
    DateTime.utc(2025, 3, 25): [
      {
        "sequence_id": 3,
        "sequence_name": "스트레칭",
        "result_status": "N",
        "percent": "0",
        "image": 'assets/images/Uttana_shishosana.png'
      }
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final displayDay = _selectedDay ?? _focusedDay;
    return Scaffold(
      appBar: AppBar(
        title: Text('활동', style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('주간리포트', style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
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
              style: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _getEventsForDay(displayDay)
              .map((event) {
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
                              child: Image.asset(
                                'assets/images/Uttana_Shishosana.png',
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Icon(
                              isDone ? Icons.check_circle : Icons.more_horiz,
                              size: 16,
                              color: isDone ? Color(0xFF7ECECA) : Colors.black54,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: parsedValue / 100,
                                    backgroundColor: Color(0xffE8FAF1),
                                    color: Color(0xff7ECECA),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(percentText, style: TextStyle(fontFamily: 'Pretendard', fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );})
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget calendar() {
    return TableCalendar(
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontFamily: 'Pretendard'),
        weekendStyle: TextStyle(fontFamily: 'Pretendard'),
      ),
      focusedDay: _focusedDay,
      firstDay: DateTime.now().subtract(Duration(days: 365 * 10)),
      lastDay: DateTime.now().add(Duration(days: 365 * 10)),
      locale: 'ko-KR',
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: _getEventsForDay,
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold),
        titleCentered: true,
        formatButtonVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(fontFamily: 'Pretendard'),
        selectedTextStyle: TextStyle(fontFamily: 'Pretendard', color: Colors.white),
        todayTextStyle: TextStyle(fontFamily: 'Pretendard'),
        selectedDecoration: BoxDecoration(
          color: Color(0xFF7ECECA),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Color(0xFF7ECECA),
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          switch (day.weekday) {
            case 1:
              return Center(child: Text('월', style: TextStyle(fontFamily: 'Pretendard')));
            case 2:
              return Center(child: Text('화', style: TextStyle(fontFamily: 'Pretendard')));
            case 3:
              return Center(child: Text('수', style: TextStyle(fontFamily: 'Pretendard')));
            case 4:
              return Center(child: Text('목', style: TextStyle(fontFamily: 'Pretendard')));
            case 5:
              return Center(child: Text('금', style: TextStyle(fontFamily: 'Pretendard')));
            case 6:
              return Center(child: Text('토', style: TextStyle(fontFamily: 'Pretendard')));
            case 7:
              return Center(child: Text('일', style: TextStyle(fontFamily: 'Pretendard')));
            default:
              return null;
          }
        },
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty && !isSameDay(day, _selectedDay)) {
            return Positioned(
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
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
