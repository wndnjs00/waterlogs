class StreakCalculator {
  static int calculate({
    required String? lastGoalDate,
    required String today,
    required String yesterday,
    required int currentStreak,
    required bool reachedGoalFirstTime,
  }) {
    if (!reachedGoalFirstTime) return currentStreak;

    if (lastGoalDate == null) return 1;
    if (lastGoalDate == today) return currentStreak;
    if (lastGoalDate == yesterday) return currentStreak + 1;

    return 1;
  }
}