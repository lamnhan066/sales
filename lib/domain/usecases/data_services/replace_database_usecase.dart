import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';

class ReplaceDatabaseUsecase implements UseCase<void, DataImportResult> {

  const ReplaceDatabaseUsecase(this._service);
  final DatabaseService _service;

  @override
  Future<void> call(DataImportResult params) {
    return _service.replaceDatabase(params);
  }
}
