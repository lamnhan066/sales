import 'package:sales/domain/exceptions/credentials_exception.dart';

class InvalidCacheCredentialsException extends CredentialsException {
  InvalidCacheCredentialsException(super.message);
}
