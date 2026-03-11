import '../model/temp_model.dart';
import '../repository/temp_repository.dart';

class TempUseCase {
  final TempRepository _repository;

  const TempUseCase(this._repository);

  TempModel call() {
    return _repository.getTempModel();
  }
}