import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';

class CircularWaterProgress extends StatelessWidget {
  final Map<String, int> beverages;
  final int waterCups;
  final int target;
  final int streak;

  const CircularWaterProgress({
    super.key,
    required this.beverages,
    required this.waterCups,
    required this.target,
    required this.streak,
  });

  static const double _innerSize = 100;
  static const double _ringSize = 180;
  static const double _strokeWidth = 16;

  int _cupsOf(BeverageType type) => (beverages[type.id] ?? 0) ~/ 250;

  int get _totalCups =>
      BeverageType.values.fold(0, (sum, type) => sum + _cupsOf(type));

  List<_RingSegment> get _segments => [
    for (final type in BeverageType.values)
      if (_cupsOf(type) > 0)
        _RingSegment(color: type.color, cups: _cupsOf(type)),
  ];

  @override
  Widget build(BuildContext context) {
    final totalCups = _totalCups;
    final segments = _segments;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: totalCups.toDouble()),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, revealedCups, _) {
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
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: _ringSize,
                      height: _ringSize,
                      child: CustomPaint(
                        painter: _MultiBeverageRingPainter(
                          segments: segments,
                          revealedCups: revealedCups,
                          target: target,
                          trackColor: AppColors.circularProgressGray,
                          strokeWidth: _strokeWidth,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _innerSize,
                      height: _innerSize,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.circularProgressCircleBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$totalCups',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainBlue,
                                ),
                              ),
                              Text(
                                '/ $target 잔',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (segments.isNotEmpty) ...[
                const SizedBox(height: 16),
                _BeverageCountLegend(beverages: beverages),
              ],
              const SizedBox(height: 20),
              Text(
                waterCups >= target
                    ? '🎉목표 달성!'
                    : '${target - waterCups}잔 더 마셔요!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$streak일 연속',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BeverageCountLegend extends StatelessWidget {
  final Map<String, int> beverages;

  const _BeverageCountLegend({required this.beverages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 14,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (final type in BeverageType.values)
            if ((beverages[type.id] ?? 0) ~/ 250 > 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: type.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${type.label} ${(beverages[type.id] ?? 0) ~/ 250}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _RingSegment {
  final Color color;
  final int cups;

  const _RingSegment({required this.color, required this.cups});
}

class _MultiBeverageRingPainter extends CustomPainter {
  final List<_RingSegment> segments;
  final double revealedCups;
  final int target;
  final Color trackColor;
  final double strokeWidth;

  const _MultiBeverageRingPainter({
    required this.segments,
    required this.revealedCups,
    required this.target,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    final denom = math.max(target.toDouble(), revealedCups);
    if (denom <= 0 || revealedCups <= 0) return;

    var remaining = revealedCups;
    var start = -math.pi / 2;
    for (final segment in segments) {
      if (remaining <= 0) break;
      final show = math.min(segment.cups.toDouble(), remaining);
      remaining -= show;
      final sweep = (show / denom) * 2 * math.pi;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = segment.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _MultiBeverageRingPainter oldDelegate) {
    return oldDelegate.revealedCups != revealedCups ||
        oldDelegate.target != target ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.segments.length != segments.length ||
        !_sameSegments(oldDelegate.segments, segments);
  }

  bool _sameSegments(List<_RingSegment> a, List<_RingSegment> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i].color != b[i].color || a[i].cups != b[i].cups) return false;
    }
    return true;
  }
}
