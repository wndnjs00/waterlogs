import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
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

  Map<int, List<WaterLog>> _groupByWeek() {
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
    return grouped;
  }

  double _avgFor(List<WaterLog> weekLogs, BeverageType type) {
    if (weekLogs.isEmpty) return 0.0;
    final sumMl = weekLogs.fold<int>(0, (s, l) => s + (l.beverages[type.id] ?? 0),);
    final cups = sumMl / 250.0;
    final avg = cups / weekLogs.length;
    return avg.clamp(0.0, _maxY);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByWeek();

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
                for (final t in BeverageType.values)
                  LineChartBarData(
                    spots: List.generate(4, (i) {
                      final weekLogs = grouped[i + 1] ?? const <WaterLog>[];
                      return FlSpot(i.toDouble(), _avgFor(weekLogs, t));
                    }),
                    isCurved: false,
                    color: t == BeverageType.water ? AppColors.mainBlue : t.color,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4.5,
                          color: barData.color ?? t.color,
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
        const SizedBox(height: 10),
        _Legend(),
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

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: [
          for (final t in BeverageType.values)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: t.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  t.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
