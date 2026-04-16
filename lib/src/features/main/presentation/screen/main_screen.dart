import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/core/ads/admob_banner.dart';
import 'package:waterlogs/src/features/main/presentation/di/water_providers.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/main_navigation_content.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/dialog/beverage_intake_dialog.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfUser());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ref.read(waterViewModelProvider.notifier).saveToCloudIfNeeded();
    }
  }

  void _loadIfUser() {
    final user = ref.read(authViewModelProvider).user;
    if (user != null) {
      ref.read(waterViewModelProvider.notifier).loadToday(
            user.uid,
            dailyGoal: user.dailyGoal ?? 8,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // auth 토스트는 MainShellPage에서만 표시 (중복 SnackBar 방지)
    ref.listen<AuthViewState>(authViewModelProvider, (prev, next) {
      final user = next.user;
      if (user != null) {
        ref.read(waterViewModelProvider.notifier).loadToday(
              user.uid,
              dailyGoal: user.dailyGoal ?? 8,
            );
      }
    });

    ref.listen<WaterViewState>(waterViewModelProvider, (prev, next) {
      final msg = next.errorMessage;
      if (msg != null && msg.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        ref.read(waterViewModelProvider.notifier).clearError();
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final waterState = ref.watch(waterViewModelProvider);

    final user = authState.user;
    final todayLog = waterState.todayLog;

    if (user == null || todayLog == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: MainNavigationContent(
            log: todayLog,
            streakDays: user.streakDays ?? 0,
            onAdd: () => ref.read(waterViewModelProvider.notifier).addCup(),
            onRemove: () => ref.read(waterViewModelProvider.notifier).removeCup(),
            onOpenDrinkDialog: () async {
              final result = await BeverageIntakeDialog.show(context);
              if (!context.mounted) return;
              if (result == null) return;
              ref
                  .read(waterViewModelProvider.notifier)
                  .selectBeverage(result.type, result.ml);
            },
            selectedBeverageLabel: waterState.selectedBeverage.label,
            servingMl: waterState.servingMl,
            hasUnsavedChanges: waterState.hasUnsavedChanges,
            isSaving: waterState.isUpdating,
            onSave: () => ref.read(waterViewModelProvider.notifier).saveToCloud(),
            weeklyLogs: waterState.weeklyLogs,
            monthlyLogs: waterState.monthlyLogs,
            dailyGoal: user.dailyGoal,
          ),
        ),
        const SafeArea(
          top: false,
          child: AdmobBanner(),
        ),
      ],
    );
  }
}