import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';

class WaterControlSection extends StatelessWidget {
  final int cups;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool hasUnsavedChanges;
  final bool isSaving;
  final VoidCallback onSave;

  const WaterControlSection({
    super.key,
    required this.cups,
    required this.onAdd,
    required this.onRemove,
    required this.hasUnsavedChanges,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '물 한 잔 마셨나요?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundedButton(
                  backgroundColor: AppColors.circularProgressGray,
                  contentColor: Colors.grey.shade800,
                  text: '-',
                  onPressed: onRemove,
                ),
                Container(
                  width: 150,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.circularProgressCircleBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 28,
                        color: AppColors.mainBlue.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${cups * 250} ml',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                _RoundedButton(
                  backgroundColor: AppColors.mainBlue,
                  contentColor: Colors.white,
                  text: '+',
                  onPressed: onAdd,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '한 잔 = 250ml 기준',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: SizedBox(
                width: 140,
                child: FilledButton(
                  onPressed: (hasUnsavedChanges && !isSaving) ? onSave : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.mainBlue,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  final Color backgroundColor;
  final Color contentColor;
  final String text;
  final VoidCallback onPressed;

  const _RoundedButton({
    required this.backgroundColor,
    required this.contentColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
