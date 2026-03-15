import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';

class WeeklyChartContent extends StatelessWidget {
  final List<WaterLog> logs;
  final int? goal;

  const WeeklyChartContent({
    super.key,
    required this.logs,
    this.goal,
  });

  static const _weekDays = ['월', '화', '수', '목', '금', '토', '일'];
  static const _maxY = 10.0;

  List<double> _yValues() {
    final map = <int, double>{};
    for (final log in logs) {
      final dt = DateTime.tryParse(log.date);
      if (dt != null) {
        final weekday = dt.weekday;
        map[weekday - 1] = log.cups.toDouble();
      }
    }
    return List.generate(7, (i) => map[i] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final values = _yValues();

    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          maxY: _maxY,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i >= 0 && i < _weekDays.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _weekDays[i],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 28,
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i].clamp(0.0, _maxY),
                  color: AppColors.mainBlue,
                  width: 15,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: _maxY,
                    color: AppColors.circularProgressGray.withValues(alpha: 0.3),
                  ),
                ),
              ],
              showingTooltipIndicators: [],
            );
          }),
          alignment: BarChartAlignment.spaceAround,
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
