abstract class Failure implements Exception {

  const Failure(this.message, [this.details]);
  final String message;
  final dynamic details;

  @override
  String toString() => 'Failure(message: $message, details: $details)';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.details]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.details]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.details]);
}

class ImportFailure extends Failure {
  const ImportFailure(super.message, [super.details]);
}

class BackupFailure extends Failure {
  const BackupFailure(super.message, [super.details]);
}
