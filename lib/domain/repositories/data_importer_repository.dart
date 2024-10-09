import 'package:sales/domain/entities/data_import_result.dart';

abstract class DataImporterRepository {
  Future<DataImportResult?> importData();
}
