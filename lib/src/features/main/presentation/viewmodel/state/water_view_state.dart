import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';

part 'water_view_state.freezed.dart';

@freezed
class WaterViewState with _$WaterViewState {
  const factory WaterViewState({
    WaterLog? todayLog,
    @Default(false) bool isUpdating,
    /// Firestore에 반영되지 않은 로컬 변경이 있음 (+/- 후 저장 전)
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<WaterLog> weeklyLogs,
    @Default([]) List<WaterLog> monthlyLogs,
    String? errorMessage,
  }) = _WaterViewState;

  const WaterViewState._();
}
