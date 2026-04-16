import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/dialog/waterlog_base_dialog.dart';

class BeverageIntakeResult {
  final BeverageType type;
  final int ml;

  const BeverageIntakeResult(this.type, this.ml);
}

class BeverageIntakeDialog extends StatefulWidget {
  const BeverageIntakeDialog({super.key});

  static Future<BeverageIntakeResult?> show(BuildContext context) {
    return showDialog<BeverageIntakeResult>(
      context: context,
      builder: (_) => const BeverageIntakeDialog(),
    );
  }

  @override
  State<BeverageIntakeDialog> createState() => _BeverageIntakeDialogState();
}

class _BeverageIntakeDialogState extends State<BeverageIntakeDialog> {
  BeverageType _selected = BeverageType.water;
  int _ml = 250;

  @override
  Widget build(BuildContext context) {
    return WaterLogBaseDialog(
      title: '${_selected.label} 한 잔 마셨나요?',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BeveragePicker(
            selected: _selected,
            onSelected: (t) => setState(() {
              final changed = t != _selected;
              _selected = t;
              // 음료를 바꾸면 기본값으 리셋
              if (changed) _ml = 250;
            }),
          ),
          const SizedBox(height: 16),
          _MlStepper(
            ml: _ml,
            onChanged: (v) => setState(() => _ml = v),
          ),
          const SizedBox(height: 12),
          _PresetRow(
            selectedMl: _ml,
            onSelected: (v) => setState(() => _ml = v),
          ),
        ],
      ),
      confirmText: '확인',
      cancelText: '취소',
      onCancel: () => Navigator.of(context).pop(null),
      onConfirm: () => Navigator.of(context).pop(BeverageIntakeResult(_selected, _ml)),
    );
  }
}

class _BeveragePicker extends StatelessWidget {
  const _BeveragePicker({
    required this.selected,
    required this.onSelected,
  });

  final BeverageType selected;
  final ValueChanged<BeverageType> onSelected;

  @override
  Widget build(BuildContext context) {

    final items = <BeverageType>[
      BeverageType.water,
      BeverageType.tea,
      BeverageType.coffee,
      BeverageType.juice,
      BeverageType.soda,
      BeverageType.milk,
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final t in items)
          _BeverageTile(
            type: t,
            selected: t == selected,
            onTap: () => onSelected(t),
          ),
      ],
    );
  }
}

class _BeverageTile extends StatelessWidget {
  const _BeverageTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final BeverageType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected ? type.color : Colors.grey.shade300;
    final bg = selected ? type.color.withValues(alpha: 0.08) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              type.assetPath,
              width: 45,
              height: 45,
              errorBuilder: (_, __, ___) => Icon(type.icon, size: 28, color: type.color),
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade900,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MlStepper extends StatelessWidget {
  const _MlStepper({
    required this.ml,
    required this.onChanged,
  });

  final int ml;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SquareButton(
          icon: Icons.remove,
          onTap: () => onChanged((ml - 50).clamp(50, 2000)),
        ),
        const SizedBox(width: 12),
        Container(
          width: 120,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade500),
          ),
          child: Text(
            '$ml ml',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        _SquareButton(
          icon: Icons.add,
          onTap: () => onChanged((ml + 50).clamp(50, 2000)),
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: Colors.grey.shade800),
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.selectedMl,
    required this.onSelected,
  });

  final int selectedMl;
  final ValueChanged<int> onSelected;

  static const presets = [150, 200, 250, 350, 500];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final v in presets)
          _PresetChip(
            text: '${v}ml',
            selected: v == selectedMl,
            onTap: () => onSelected(v),
          ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.mainBlue.withValues(alpha: 0.08) : Colors.white;
    final border = selected ? AppColors.mainBlue : Colors.grey.shade300;
    final fg = selected ? AppColors.mainBlue : Colors.grey.shade900;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fg),
        ),
      ),
    );
  }
}

