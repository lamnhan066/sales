import 'package:language_helper/language_helper.dart';
import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class RestoreException extends InfrastructureException {
  RestoreException([String? message, StackTrace? stackTrace]) : super(message ?? 'Khôi phục lỗi'.tr, stackTrace);
}
