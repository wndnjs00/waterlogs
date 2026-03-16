import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

void showBadgeInfoDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '뱃지 기능 개발중입니다.',
            style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '조금만 기다려주세요!',
            style: Theme.of(
              dialogContext,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.mainBlue,
                side: const BorderSide(color: AppColors.mainBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                '확인',
                style: Theme.of(dialogContext).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
