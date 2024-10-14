import 'package:language_helper/language_helper.dart';
import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class DataImportException extends InfrastructureException {
  DataImportException([String? message, StackTrace? stackTrace]) : super(message ?? 'Lỗi nhập dữ liệu'.tr, stackTrace);
}
