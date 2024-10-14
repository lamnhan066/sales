import 'package:language_helper/language_helper.dart';
import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class BackupException extends InfrastructureException {
  BackupException([String? message, StackTrace? stackTrace]) : super(message ?? 'Sao lưu lỗi'.tr, stackTrace);
}
