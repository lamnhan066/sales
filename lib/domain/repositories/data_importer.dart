import 'package:sales/domain/entities/data_import_result.dart';

abstract class DataImporter {
  Future<DataImportResult?> importData();
}
