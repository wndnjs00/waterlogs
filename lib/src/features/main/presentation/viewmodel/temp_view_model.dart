import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/temp_model.dart';
import '../../domain/usecase/temp_usecase.dart';
import '../di/main_providers.dart';

class TempViewModel extends StateNotifier<TempModel> {
  TempViewModel(this._getTempModelUseCase)
      : super(_getTempModelUseCase());

  final TempUseCase _getTempModelUseCase;

  void refresh() {
    state = _getTempModelUseCase();
  }
}


final tempViewModelProvider =
    StateNotifierProvider<TempViewModel, TempModel>((ref) {
  final useCase = ref.watch(getTempModelUseCaseProvider);
  return TempViewModel(useCase);
});