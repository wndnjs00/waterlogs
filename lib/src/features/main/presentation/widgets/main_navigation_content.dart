import 'package:flutter/material.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/chart_segment_control.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/circular_water_progress.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/monthly_chart_content.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/water_control_section.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/weekly_chart_content.dart';

class MainNavigationContent extends StatefulWidget {
  final WaterLog log;
  final int streakDays;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onOpenDrinkDialog;
  final String selectedBeverageLabel;
  final int servingMl;
  final bool hasUnsavedChanges;
  final bool isSaving;
  final VoidCallback onSave;
  final List<WaterLog> weeklyLogs;
  final List<WaterLog> monthlyLogs;
  final int? dailyGoal;

  const MainNavigationContent({
    super.key,
    required this.log,
    required this.streakDays,
    required this.onAdd,
    required this.onRemove,
    required this.onOpenDrinkDialog,
    required this.selectedBeverageLabel,
    required this.servingMl,
    required this.hasUnsavedChanges,
    required this.isSaving,
    required this.onSave,
    required this.weeklyLogs,
    required this.monthlyLogs,
    this.dailyGoal,
  });

  @override
  State<MainNavigationContent> createState() => _MainNavigationContentState();
}

class _MainNavigationContentState extends State<MainNavigationContent> {
  ChartType _selectedChart = ChartType.weekly;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          CircularWaterProgress(
            cups: widget.log.cups,
            target: widget.log.targetCups,
            streak: widget.streakDays,
          ),
          const SizedBox(height: 24),
          WaterControlSection(
            beverageLabel: widget.selectedBeverageLabel,
            servingMl: widget.servingMl,
            onAdd: widget.onAdd,
            onRemove: widget.onRemove,
            onOpenDialog: widget.onOpenDrinkDialog,
            hasUnsavedChanges: widget.hasUnsavedChanges,
            isSaving: widget.isSaving,
            onSave: widget.onSave,
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                ChartSegmentControl(
                  selectedChart: _selectedChart,
                  onSelectedChange: (v) => setState(() => _selectedChart = v),
                ),
                const SizedBox(height: 24),
                if (_selectedChart == ChartType.weekly)
                  WeeklyChartContent(
                    logs: widget.weeklyLogs,
                    goal: widget.dailyGoal,
                  )
                else
                  MonthlyChartContent(
                    logs: widget.monthlyLogs,
                    monthAvg: _monthAvg(widget.monthlyLogs),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  double _monthAvg(List<WaterLog> logs) {
    if (logs.isEmpty) return 0;
    final sumCups = logs.fold<double>(0, (s, l) => s + (l.totalMl / 250.0));
    return sumCups / logs.length;
  }
}
