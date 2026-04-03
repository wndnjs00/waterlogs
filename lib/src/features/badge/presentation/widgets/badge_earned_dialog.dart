import 'package:flutter/material.dart';

import 'package:waterlogs/src/core/util/asset_path.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';

import 'waterlog_surface_dialog.dart';

class BadgeEarnedDialog extends StatefulWidget {
  final String badgeKey;
  final String badgeName;

  const BadgeEarnedDialog({
    super.key,
    required this.badgeKey,
    required this.badgeName,
  });

  @override
  State<BadgeEarnedDialog> createState() => _BadgeEarnedDialogState();
}

class _BadgeEarnedDialogState extends State<BadgeEarnedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaterLogSurfaceDialog(
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎉 새로운 뱃지 획득!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              _badgeImageAsset(widget.badgeKey),
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              widget.badgeName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              '획득 완료',
              style: TextStyle(
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _badgeImageAsset(String key) {
    switch (key) {
      case BadgeType.day2L:
      case BadgeType.week7days:
      case BadgeType.month30days:
      case BadgeType.king6months:
        return AssetPath.badgeActive;
      default:
        return AssetPath.badgeInactive;
    }
  }
}
