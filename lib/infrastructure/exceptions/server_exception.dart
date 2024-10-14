import 'package:language_helper/language_helper.dart';
import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class ServerException extends InfrastructureException {
  ServerException([String? message, StackTrace? stackTrace]) : super(message ?? 'Lỗi máy chủ'.tr, stackTrace);
}
