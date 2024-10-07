abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server failure occurred']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache failure occurred']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Network failure occurred']);
}
