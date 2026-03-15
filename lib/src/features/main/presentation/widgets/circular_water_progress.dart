import 'package:flutter/material.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';

class CircularWaterProgress extends StatelessWidget {
  final int cups;
  final int target;
  final int streak;

  const CircularWaterProgress({
    super.key,
    required this.cups,
    required this.target,
    required this.streak,
  });

  static const double _innerSize = 100;

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (cups.clamp(0, target) / target) : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
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
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: AppColors.circularProgressGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mainBlue),
                      ),
                    ),
                    SizedBox(
                      width: _innerSize,
                      height: _innerSize,
                      child: ClipOval(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: _innerSize,
                              height: _innerSize,
                              color: AppColors.circularProgressCircleBlue,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: _innerSize * value.clamp(0.0, 1.0),
                                width: _innerSize,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.mainBlue.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$cups',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainBlue,
                                    ),
                                  ),
                                  Text(
                                    '/ $target 잔',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                cups >= target ? '🎉목표 달성!' : '${target - cups}잔 더 마셔요!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${streak}일 연속',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
