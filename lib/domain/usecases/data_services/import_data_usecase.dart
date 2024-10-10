import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';

class ImportDataUseCase implements UseCase<DataImportResult?, NoParams> {
  final DataImporterRepository _importer;

  const ImportDataUseCase(this._importer);

  @override
  Future<DataImportResult?> call(NoParams params) {
    return _importer.importData();
  }
}
