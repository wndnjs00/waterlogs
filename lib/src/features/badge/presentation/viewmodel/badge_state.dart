import 'package:waterlogs/src/features/badge/domain/model/badge.dart';

class BadgeState {
  final Map<String, Badge> badges;
  final List<String> pendingEarnedDialogKeys;
  final String? toastMessage;

  const BadgeState({
    this.badges = const {},
    this.pendingEarnedDialogKeys = const [],
    this.toastMessage,
  });

  BadgeState copyWith({
    Map<String, Badge>? badges,
    List<String>? pendingEarnedDialogKeys,
    String? toastMessage,
  }) {
    return BadgeState(
      badges: badges ?? this.badges,
      pendingEarnedDialogKeys:
          pendingEarnedDialogKeys ?? this.pendingEarnedDialogKeys,
      toastMessage: toastMessage,
    );
  }
}
