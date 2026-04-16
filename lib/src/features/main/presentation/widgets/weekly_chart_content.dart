import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
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

  Map<int, Map<BeverageType, double>> _valuesByDay() {
    final map = <int, Map<BeverageType, double>>{};
    for (final log in logs) {
      final dt = DateTime.tryParse(log.date);
      if (dt != null) {
        final weekday = dt.weekday;
        final dayIdx = weekday - 1;
        final beverageCups = <BeverageType, double>{};
        for (final t in BeverageType.values) {
          final ml = log.beverages[t.id] ?? 0;
          beverageCups[t] = ml / 250.0;
        }
        map[dayIdx] = beverageCups;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final byDay = _valuesByDay();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
                final items = byDay[i] ?? const <BeverageType, double>{};

                double running = 0.0;
                final stacks = <BarChartRodStackItem>[];
                for (final t in BeverageType.values) {
                  final v = (items[t] ?? 0.0).clamp(0.0, _maxY);
                  if (v <= 0) continue;
                  final from = running;
                  running = (running + v).clamp(0.0, _maxY);
                  stacks.add(BarChartRodStackItem(from, running, t.color));
                  if (running >= _maxY) break;
                }

                final total = running.clamp(0.0, _maxY);

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: total,
                      width: 15,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      rodStackItems: stacks,
                      color: stacks.isEmpty ? AppColors.mainBlue : null,
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
        ),
        const SizedBox(height: 10),
        _Legend(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '※ 1잔 = 250ml 기준',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
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
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final t in BeverageType.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: t.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                t.label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
      ],
    );
  }
}
