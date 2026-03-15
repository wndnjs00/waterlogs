import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';

class MonthlyChartContent extends StatelessWidget {
  final List<WaterLog> logs;
  final double monthAvg;

  const MonthlyChartContent({
    super.key,
    required this.logs,
    required this.monthAvg,
  });

  static const _weekLabels = ['1주차', '2주차', '3주차', '4주차'];
  static const _maxY = 10.0;

  List<double> _weeklyAverages() {
    final grouped = <int, List<WaterLog>>{};
    for (final log in logs) {
      final dt = DateTime.tryParse(log.date);
      if (dt != null) {
        final day = dt.day;
        int week;
        if (day <= 7) {
          week = 1;
        } else if (day <= 14) {
          week = 2;
        } else if (day <= 21) {
          week = 3;
        } else {
          week = 4;
        }
        grouped.putIfAbsent(week, () => []).add(log);
      }
    }
    return List.generate(4, (i) {
      final weekLogs = grouped[i + 1] ?? [];
      if (weekLogs.isEmpty) return 0.0;
      final sum = weekLogs.fold<int>(0, (s, l) => s + l.cups);
      return (sum / weekLogs.length).clamp(0.0, _maxY);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spots = _weeklyAverages()
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 260,
          child: LineChart(
            LineChartData(
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
                      if (i >= 0 && i < _weekLabels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _weekLabels[i],
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
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: AppColors.mainBlue,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.mainBlue,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 300),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '이번 달 평균: ${monthAvg.toStringAsFixed(1)}잔/일',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
