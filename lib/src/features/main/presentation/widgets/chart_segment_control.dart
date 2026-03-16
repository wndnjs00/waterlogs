import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';

enum ChartType { weekly, monthly }

class ChartSegmentControl extends StatelessWidget {
  final ChartType selectedChart;
  final ValueChanged<ChartType> onSelectedChange;

  const ChartSegmentControl({
    super.key,
    required this.selectedChart,
    required this.onSelectedChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              text: '주간 수분 섭취량',
              selected: selectedChart == ChartType.weekly,
              onTap: () => onSelectedChange(ChartType.weekly),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              text: '월간 평균 섭취량',
              selected: selectedChart == ChartType.monthly,
              onTap: () => onSelectedChange(ChartType.monthly),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? AppColors.mainBlue : Colors.grey.shade800,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
