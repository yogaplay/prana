import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';

class YogaBmiChart extends StatelessWidget {
  final List<WeeklyYogaData> data;
  const YogaBmiChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final thisWeek = data.last.bmi;
    final lastWeek = data[data.length - 2].bmi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('지난 주에 비해', style: TextStyle(fontSize: 16)),
        buildBmiDifferenceMessage(thisWeek, lastWeek),
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
              Text('금주 체질량 지수', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text(
                _formatBmi(thisWeek),
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

  String _formatBmi(double bmi) {
    if (bmi >= 18.5 && bmi <= 24.9) {
      return '${bmi.toStringAsFixed(1)} (정상)';
    } else if (bmi < 18.5) {
      return '${bmi.toStringAsFixed(1)} (저체중)';
    } else if (bmi >= 25 && bmi <= 29.9) {
      return '${bmi.toStringAsFixed(1)} (과체중)';
    } else {
      return '${bmi.toStringAsFixed(1)} (비만)';
    }
  }

  Widget buildBmiDifferenceMessage(double thisWeek, double lastWeek) {
    final diff = thisWeek - lastWeek;

    if (diff == 0) {
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: AppColors.blackText),
          children: [
            TextSpan(text: '체질량 지수의 '),
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
    final diffText = '${diff.abs()}';
    final emphasis = isIncrease ? '증가' : '감소';

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: AppColors.blackText),
        children: [
          TextSpan(text: 'BMI 지수가 '),
          TextSpan(
            text: '$diffText $emphasis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.blackText,
            ),
          ),
          TextSpan(text: '했습니다.'),
        ],
      ),
    );
  }

  LineChartData _buildChartData(List<WeeklyYogaData> data) {
    return LineChartData(
      minY: 16,
      maxY: 40,
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() == 16 || value.toInt() == 40) {
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
            reservedSize: 36,
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
        horizontalInterval: 8,
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
          isCurved: true,
          spots: List.generate(
            data.length,
            (i) => FlSpot(i.toDouble(), data[i].bmi.toDouble()),
          ),
          color: AppColors.primary,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }
}
