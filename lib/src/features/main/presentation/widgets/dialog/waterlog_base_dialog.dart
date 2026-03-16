import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';


class WaterLogBaseDialog extends StatelessWidget {
  const WaterLogBaseDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  final String title;
  final Widget content;
  final String confirmText;
  final String? cancelText;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const cancelBorderGray = AppColors.circularProgressGray;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          content,
          const SizedBox(height: 24),

          Row(
            children: [
              if (cancelText != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: cancelBorderGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      cancelText!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onConfirm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mainBlue,
                    side: const BorderSide(color: AppColors.mainBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    confirmText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}