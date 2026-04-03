import 'package:waterlogs/src/features/badge/domain/model/badge.dart';

class BadgeState {
  final Map<String, Badge> badges;
  final List<String> pendingEarnedDialogKeys;

  const BadgeState({
    this.badges = const {},
    this.pendingEarnedDialogKeys = const [],
  });

  BadgeState copyWith({
    Map<String, Badge>? badges,
    List<String>? pendingEarnedDialogKeys,
  }) {
    return BadgeState(
      badges: badges ?? this.badges,
      pendingEarnedDialogKeys:
          pendingEarnedDialogKeys ?? this.pendingEarnedDialogKeys,
    );
  }
}
