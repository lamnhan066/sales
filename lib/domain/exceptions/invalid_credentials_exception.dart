import 'package:sales/domain/exceptions/credentials_exception.dart';

class InvalidCredentialsException extends CredentialsException {
  const InvalidCredentialsException(super.message);
}
