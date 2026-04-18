import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';

part 'water_view_state.freezed.dart';

@freezed
class WaterViewState with _$WaterViewState {
  const factory WaterViewState({
    WaterLog? todayLog,
    @Default(false) bool isUpdating,
    /// Firestore에 반영되지 않은 로컬 변경이 있음 (저장버튼 누르기 전)
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<WaterLog> weeklyLogs,
    @Default([]) List<WaterLog> monthlyLogs,
    @Default(BeverageType.water) BeverageType selectedBeverage,
    /// 현재 선택된 음료한잔의 용량(ml). (가운데 박스 -> 이값 고정표시)
    @Default(250) int servingMl,
    /// 커피/주스/탄산/우유 해금 개수 (0~4)
    @Default(0) int unlockedPremiumBeverageCount,
    /// 다음 해금까지 누적된 보상형 광고 시청 횟수 (0~1)
    @Default(0) int rewardedAdProgress,
    String? errorMessage,
  }) = _WaterViewState;

  const WaterViewState._();
}
