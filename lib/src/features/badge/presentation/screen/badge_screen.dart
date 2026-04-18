import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waterlogs/src/core/ads/admob_banner.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/badge/presentation/di/badge_providers.dart';
import 'package:waterlogs/src/features/badge/presentation/viewmodel/badge_state.dart';
import 'package:waterlogs/src/features/badge/presentation/widgets/badge_earned_dialog.dart';
import 'package:waterlogs/src/features/badge/presentation/widgets/badge_grid_item.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';

class BadgeScreen extends ConsumerStatefulWidget {
  const BadgeScreen({super.key});

  @override
  ConsumerState<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends ConsumerState<BadgeScreen> {
  static const _badgeOrder = [
    BadgeType.day2L,
    BadgeType.week7days,
    BadgeType.month30days,
    BadgeType.king6months,
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen<BadgeState>(badgeViewModelProvider, (prev, next) {
      final msg = next.toastMessage;

      if (msg != null && msg.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        ref.read(badgeViewModelProvider.notifier).clearToast();
      }

      final keys = next.pendingEarnedDialogKeys;
      if (keys.isEmpty) return;

      final nextFirst = keys.first;
      final prevFirst = prev != null && prev.pendingEarnedDialogKeys.isNotEmpty
          ? prev.pendingEarnedDialogKeys.first
          : null;

      if (prevFirst == nextFirst) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final name = next.badges[nextFirst]?.name ?? '';
        showEarnedDialog(context, nextFirst, name);
      });
    });

    final state = ref.watch(badgeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: const Text('물뱃지'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.mainBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // 셀 높이 확보 (이미지 + 제목 2줄 + 상태 한 줄)
                  childAspectRatio: 0.72,
                ),
                itemCount: _badgeOrder.length,
                itemBuilder: (context, index) {
                  final key = _badgeOrder[index];
                  final badge = state.badges[key];
                  return BadgeGridItem(
                    isAchieved: badge != null,
                    title: badge?.name ?? '🔒잠김',
                  );
                },
              ),
            ),
          ),
          const SafeArea(
            top: false,
            child: AdmobBanner(),
          ),
        ],
      ),
    );
  }

  Future<void> showEarnedDialog(
    BuildContext context,
    String badgeKey,
    String badgeName,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BadgeEarnedDialog(
        badgeKey: badgeKey,
        badgeName: badgeName,
      ),
    );
    if (mounted) {
      ref.read(badgeViewModelProvider.notifier).dismissCurrentEarnedDialog();
    }
  }
}
