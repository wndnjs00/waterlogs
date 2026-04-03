import 'package:flutter/material.dart';

import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/core/util/asset_path.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';

import 'waterlog_surface_dialog.dart';

class BadgeDialog extends StatefulWidget {
  final String badgeKey;
  final VoidCallback onDismiss;

  const BadgeDialog({
    super.key,
    required this.badgeKey,
    required this.onDismiss,
  });

  @override
  State<BadgeDialog> createState() => _BadgeDialogState();
}

class _BadgeDialogState extends State<BadgeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badgeName = _titleForKey(widget.badgeKey);

    return WaterLogSurfaceDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _scale,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: child,
              );
            },
            child: Image.asset(
              AssetPath.badgeActive,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            badgeName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '획득 완료 🎉',
            style: TextStyle(color: AppColors.mainBlue),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: widget.onDismiss,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.mainBlue,
              side: const BorderSide(color: AppColors.mainBlue),
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  static String _titleForKey(String key) {
    switch (key) {
      case BadgeType.day2L:
        return '하루 2L 달성';
      case BadgeType.week7days:
        return '7일 연속 달성';
      case BadgeType.month30days:
        return '30일 연속 달성';
      case BadgeType.king6months:
        return '6개월 달성';
      default:
        return '뱃지';
    }
  }
}
