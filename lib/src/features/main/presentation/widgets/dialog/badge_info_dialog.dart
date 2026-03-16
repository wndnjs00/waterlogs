import 'package:flutter/material.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/dialog/waterlog_base_dialog.dart';


void showBadgeInfoDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => WaterLogBaseDialog(
      title: '뱃지 기능 개발중입니다.',
      confirmText: '확인',
      onConfirm: () => Navigator.of(dialogContext).pop(),
      content: Text(
        '조금만 기다려주세요!',
        style: Theme.of(dialogContext)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.black),
      ),
    ),
  );
}