// Repository의 도메인 로직 결과만 담고, Firestore 구조는 DataSource가 책임진다.
class SaveWithAchievementResult {
  const SaveWithAchievementResult({
    required this.userUpdate,
    required this.createGoalNotification,
    required this.createGoalBadge,
    this.streakBadgeDocId,
  });

  final Map<String, dynamic> userUpdate;
  final bool createGoalNotification;
  final bool createGoalBadge;
  final String? streakBadgeDocId; // streak 배지 문서 ID (예: week_7days, month_30days, king_6months)
}
