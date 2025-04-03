import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';

class YogaTimeChart extends StatelessWidget {
  final List<WeeklyYogaData> data;
  const YogaTimeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final thisWeek = data.last.time;
    final lastWeek = data[data.length - 2].time;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('지난 주에 비해', style: TextStyle(fontSize: 16)),
        buildTimeDifferenceMessage(thisWeek, lastWeek),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('금주 요가 시간', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text(
                _formatMinutes(thisWeek),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: LineChart(_buildChartData(data)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '$h시간 $m분';
    if (h > 0) return '$h시간';
    return '$m분';
  }

  Widget buildTimeDifferenceMessage(int thisWeek, int lastWeek) {
    final diff = thisWeek - lastWeek;

    if (diff == 0) {
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: AppColors.blackText),
          children: [
            TextSpan(text: '요가 시간의 '),
            TextSpan(
              text: '변화가 없습니다',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.blackText,
              ),
            ),
            TextSpan(text: '.'),
          ],
        ),
      );
    }

    final isIncrease = diff > 0;
    final diffText = _formatMinutes(diff.abs());
    final emphasis = isIncrease ? '더 많이' : '더 적게';

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: AppColors.blackText),
        children: [
          TextSpan(text: '요가를 '),
          TextSpan(
            text: '$diffText $emphasis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.blackText,
            ),
          ),
          TextSpan(text: ' 했습니다.'),
        ],
      ),
    );
  }

  LineChartData _buildChartData(List<WeeklyYogaData> data) {
    final maxTime = data
        .map((e) => e.time)
        .fold<int>(0, (prev, el) => el > prev ? el : prev);
    final paddedMaxY = (maxTime * 1.2).ceil();
    final interval = (paddedMaxY / 3).ceilToDouble();
    return LineChartData(
      minY: 0,
      maxY: paddedMaxY.toDouble(),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value == 0 || value == paddedMaxY) {
                return SideTitleWidget(
                  meta: meta,
                  space: 12,
                  child: Text(
                    '${value.toInt()}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }
              return SizedBox.shrink();
            },
            reservedSize: 48,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < data.length) {
                return SideTitleWidget(
                  meta: meta,
                  space: 12,
                  child: Text(
                    data[index].label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }
              return SizedBox.shrink();
            },
            reservedSize: 48,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: interval,
        verticalInterval: 1,
        getDrawingHorizontalLine:
            (value) => FlLine(color: AppColors.lightGray, strokeWidth: 1),
        getDrawingVerticalLine:
            (value) => FlLine(color: AppColors.lightGray, strokeWidth: 1),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: false,
          spots: List.generate(
            data.length,
            (i) => FlSpot(i.toDouble(), data[i].time.toDouble()),
          ),
          color: AppColors.primary,
          dotData: FlDotData(show: true),
        ),
      ],
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (
          LineChartBarData barData,
          List<int> spotIndexes,
        ) {
          return spotIndexes.map((index) {
            return null;
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 16,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()}분',
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
