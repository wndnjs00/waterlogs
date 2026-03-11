import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/temp_data_source.dart';
import '../../data/repository/temp_repository_impl.dart';
import '../../domain/repository/temp_repository.dart';
import '../../domain/usecase/temp_usecase.dart';

// DataSource
final tempDataSourceProvider = Provider<TempDataSource>((ref) {
  return TempDataSource();
});

// Repository
final tempRepositoryProvider = Provider<TempRepository>((ref) {
  final dataSource = ref.watch(tempDataSourceProvider);
  return TempRepositoryImpl(dataSource);
});

// UseCase
final getTempModelUseCaseProvider =
    Provider<TempUseCase>((ref) {
  final repository = ref.watch(tempRepositoryProvider);
  return TempUseCase(repository);
});