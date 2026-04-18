import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/ads/admob_rewarded.dart';
import 'package:waterlogs/src/features/main/presentation/di/water_providers.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/dialog/waterlog_base_dialog.dart';

class BeverageUnlockDialog extends ConsumerStatefulWidget {
  const BeverageUnlockDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const BeverageUnlockDialog(),
    );
  }

  @override
  ConsumerState<BeverageUnlockDialog> createState() => _BeverageUnlockDialogState();
}

class _BeverageUnlockDialogState extends ConsumerState<BeverageUnlockDialog> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterViewModelProvider);
    final unlocked = state.unlockedPremiumBeverageCount;
    final progress = state.rewardedAdProgress;

    final allUnlocked = unlocked >= 4;

    return WaterLogBaseDialog(
      title: '음료 잠금 풀기',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '광고를 2회 시청하거나, 뱃지를 하나 획득할때마다,\n음료 잠금을 풀 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: (_loading || allUnlocked) ? null : _onWatchAd,
              icon: const Icon(Icons.tv),
              label: const Text('광고보고 음료잠금풀기'),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            allUnlocked ? '모든 음료가 해금되었어요' : '$progress / 2 회 시청',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _DotsIndicator(
            count: 2,
            active: allUnlocked ? 2 : progress.clamp(0, 2),
          ),
        ],
      ),
      confirmText: '닫기',
      onConfirm: () => Navigator.of(context).pop(),
      cancelText: null,
      isLoading: _loading,
    );
  }

  Future<void> _onWatchAd() async {
    setState(() => _loading = true);
    try {
      final earned = await AdmobRewarded.showOnce();
      if (!mounted) return;
      if (!earned) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('광고를 불러오지 못했어요. 잠시 후 다시 시도해주세요.')),
        );
        return;
      }

      final before = ref.read(waterViewModelProvider).unlockedPremiumBeverageCount;
      await ref.read(waterViewModelProvider.notifier).onRewardedAdEarned();
      if (!mounted) return;

      final after = ref.read(waterViewModelProvider).unlockedPremiumBeverageCount;
      if (after > before) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('음료 1개 잠금이 해제되었어요!')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i < active;
        return Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        );
      }),
    );
  }
}

