import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class CredentialsException extends InfrastructureException {
  CredentialsException([String? message, StackTrace? stackTrace]) : super(message ?? 'Lỗi xác thực', stackTrace);
}
