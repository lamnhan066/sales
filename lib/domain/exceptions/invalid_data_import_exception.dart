abstract class DataImportException implements Exception {
  final String message;
  final dynamic stackTrace;

  const DataImportException(this.message, [this.stackTrace]);
}

class InvalidDataImportException extends DataImportException {
  const InvalidDataImportException(super.message, [super.stackTrace]);
}
