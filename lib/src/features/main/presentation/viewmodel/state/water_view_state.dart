import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';

part 'water_view_state.freezed.dart';

@freezed
class WaterViewState with _$WaterViewState {
  const factory WaterViewState({
    WaterLog? todayLog,
    @Default(false) bool isUpdating,
    @Default([]) List<WaterLog> weeklyLogs,
    @Default([]) List<WaterLog> monthlyLogs,
    String? errorMessage,
  }) = _WaterViewState;

  const WaterViewState._();
}
