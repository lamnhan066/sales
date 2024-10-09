class CredentialsException implements Exception {
  final String message;
  const CredentialsException(this.message);
}

class InvalidCacheCredentialsException extends CredentialsException {
  InvalidCacheCredentialsException(super.message);
}

class InvalidCredentialsException extends CredentialsException {
  const InvalidCredentialsException(super.message);
}
