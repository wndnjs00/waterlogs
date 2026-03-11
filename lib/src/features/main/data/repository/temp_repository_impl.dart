import '../../domain/model/temp_model.dart';
import '../../domain/repository/temp_repository.dart';
import '../datasource/temp_data_source.dart';

class TempRepositoryImpl implements TempRepository {
  TempRepositoryImpl(this._dataSource);

  final TempDataSource _dataSource;

  @override
  TempModel getTempModel() {
    return _dataSource.getTempModel();
  }
}