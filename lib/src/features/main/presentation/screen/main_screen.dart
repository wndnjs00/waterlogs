import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/main/presentation/di/water_providers.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';
import 'package:waterlogs/src/features/main/presentation/widgets/main_navigation_content.dart';
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfUser());
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

    return MainNavigationContent(
      log: todayLog,
      streakDays: user.streakDays ?? 0,
      onAdd: () => ref.read(waterViewModelProvider.notifier).addCup(),
      onRemove: () => ref.read(waterViewModelProvider.notifier).removeCup(),
      weeklyLogs: waterState.weeklyLogs,
      monthlyLogs: waterState.monthlyLogs,
      dailyGoal: user.dailyGoal,
    );
  }
}