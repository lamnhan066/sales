import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';

class ReplaceDatabaseUsecase implements UseCase<void, DataImportResult> {
  final DatabaseService _service;

  const ReplaceDatabaseUsecase(this._service);

  @override
  Future<void> call(DataImportResult params) {
    return _service.replaceDatabase(params);
  }
}
